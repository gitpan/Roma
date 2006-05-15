#!/usr/bin/perl -w

package Local::Roma::Query::Comparison;
use base qw(Test::Class);

use Roma::Query::Where;
use Roma::Query::Comparison;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

sub comparisonAnd : Test(1)
{
	my $op_eq1 = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$op_eq1->add( Roma::Query::SQL::Column->new( undef, 'column1' ) );
	$op_eq1->add( Roma::Query::SQL::Literal->new( 'ABC' ) );

	my $op_eq2 = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$op_eq2->add( Roma::Query::SQL::Column->new( undef, 'column2' ) );
	$op_eq2->add( Roma::Query::SQL::Literal->new( '123' ) );

	my $op_and = Roma::Query::Where->new( $Roma::Query::Where::AND );
	$op_and->add( $op_eq1 );
	$op_and->add( $op_eq2 );

	my $s = generate_sql( $op_and );
	is( $s, "column1 = 'ABC' AND column2 = '123'" );
}

sub comparisonOr : Test(1)
{
	my $op_eq1 = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$op_eq1->add( Roma::Query::SQL::Column->new( undef, 'column1' ) );
	$op_eq1->add( Roma::Query::SQL::Literal->new( 'ABC' ) );

	my $op_eq2 = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$op_eq2->add( Roma::Query::SQL::Column->new( undef, 'column2' ) );
	$op_eq2->add( Roma::Query::SQL::Literal->new( '123' ) );

	my $op_and = Roma::Query::Where->new( $Roma::Query::Where::OR );
	$op_and->add( $op_eq1 );
	$op_and->add( $op_eq2 );

	my $s = generate_sql( $op_and );
	is( $s, "column1 = 'ABC' OR column2 = '123'" );
}

sub comparisonEqual : Test(1)
{
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'column_name' ) );
	$equal->add( Roma::Query::SQL::Literal->new( 'ABC' ) );

	my $s = generate_sql( $equal );
	is( $s, "column_name = 'ABC'" );
}

sub comparisonNotEqual : Test(1)
{
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::NOT_EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'column_name' ) );
	$equal->add( Roma::Query::SQL::Literal->new( 'ABC' ) );

	my $s = generate_sql( $equal );
	is( $s, "column_name <> 'ABC'" );
}

sub comparisonGreaterThan : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::GREATER_THAN );
	$op->add( Roma::Query::SQL::Column->new( undef, 'price' ) );
	$op->add( Roma::Query::SQL::Literal->new( '21000' ) );

	my $s = generate_sql( $op );
	is( $s, "price > '21000'" );
}

sub comparisonGreaterEqual : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::GREATER_EQUAL );
	$op->add( Roma::Query::SQL::Column->new( undef, 'price' ) );
	$op->add( Roma::Query::SQL::Literal->new( '21000' ) );

	my $s = generate_sql( $op );
	is( $s, "price >= '21000'" );
}

sub comparisonLessThan : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::LESS_THAN );
	$op->add( Roma::Query::SQL::Column->new( undef, 'price' ) );
	$op->add( Roma::Query::SQL::Literal->new( '21000' ) );

	my $s = generate_sql( $op );
	is( $s, "price < '21000'" );
}

sub comparisonLessEqual : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::LESS_EQUAL );
	$op->add( Roma::Query::SQL::Column->new( undef, 'price' ) );
	$op->add( Roma::Query::SQL::Literal->new( '21000' ) );

	my $s = generate_sql( $op );
	is( $s, "price <= '21000'" );
}

sub comparisonLike : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::LIKE );
	$op->add( Roma::Query::SQL::Column->new( undef, 'name' ) );
	$op->add( Roma::Query::SQL::Literal->new( '%something%' ) );

	my $s = generate_sql( $op );
	is( $s, 'name LIKE \'%something%\'' );
}

sub comparisonNotLike : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::NOT_LIKE );
	$op->add( Roma::Query::SQL::Column->new( undef, 'name' ) );
	$op->add( Roma::Query::SQL::Literal->new( '%something%' ) );

	my $s = generate_sql( $op );
	is( $s, 'name NOT LIKE \'%something%\'' );
}

sub comparisonILike : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::ILIKE );
	$op->add( Roma::Query::SQL::Column->new( undef, 'name' ) );
	$op->add( Roma::Query::SQL::Literal->new( '%something%' ) );

	my $s = generate_sql( $op );
	is( $s, 'name ILIKE \'%something%\'' );
}

sub comparisonNotILike : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::NOT_ILIKE );
	$op->add( Roma::Query::SQL::Column->new( undef, 'name' ) );
	$op->add( Roma::Query::SQL::Literal->new( '%something%' ) );

	my $s = generate_sql( $op );
	is( $s, 'name NOT ILIKE \'%something%\'' );
}

sub comparisonIsNull : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::IS_NULL );
	$op->add( Roma::Query::SQL::Column->new( undef, 'optional_id' ) );

	my $s = generate_sql( $op );
	is( $s, 'optional_id IS NULL' );
}

sub comparisonIsNotNull : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::IS_NOT_NULL );
	$op->add( Roma::Query::SQL::Column->new( undef, 'optional_id' ) );

	my $s = generate_sql( $op );
	is( $s, 'optional_id IS NOT NULL' );
}

sub comparisonBetween : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::BETWEEN );
	$op->add( Roma::Query::SQL::Column->new( undef, 'year' ) );
	$op->add( Roma::Query::SQL::Literal->new( '1990' ) );
	$op->add( Roma::Query::SQL::Literal->new( '2001' ) );

	my $s = generate_sql( $op );
	is( $s, "year BETWEEN '1990' AND '2001'" );
}

sub comparisonIn : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::IN );
	$op->add( Roma::Query::SQL::Column->new( undef, 'year' ) );
	$op->add( Roma::Query::SQL::Literal->new( '2000' ) );
	$op->add( Roma::Query::SQL::Literal->new( '2001' ) );

	my $s = generate_sql( $op );
	is( $s, "year IN ('2000','2001')" );
}

sub comparisonNotIn : Test(1)
{
	my $op = Roma::Query::Comparison->new( $Roma::Query::Comparison::NOT_IN );
	$op->add( Roma::Query::SQL::Column->new( undef, 'year' ) );
	$op->add( Roma::Query::SQL::Literal->new( '2000' ) );
	$op->add( Roma::Query::SQL::Literal->new( '2001' ) );

	my $s = generate_sql( $op );
	is( $s, "year NOT IN ('2000','2001')" );
}

1;

