#!/usr/bin/perl -w

package Local::Roma::Query::SQL::TTT;
use base qw(Test::Class);

use Roma::Query::SQL::TTT::Operator;
use Roma::Query::SQL::TTT::Function;
use Roma::Query::SQL::TTT::Keyword;
use Roma::Query::SQL::TTT::Join;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

sub tttOperator1 : Test(1)
{
	my $op_eq1 = Roma::Query::SQL::TTT::Operator->new( '=' );
	$op_eq1->add( Roma::Query::SQL::Column->new(undef, 'column1') );
	$op_eq1->add( Roma::Query::SQL::Literal->new('ABC') );

	my $op_eq2 = Roma::Query::SQL::TTT::Operator->new( '=' );
	$op_eq2->add( Roma::Query::SQL::Column->new(undef, 'column2') );
	$op_eq2->add( Roma::Query::SQL::Literal->new('123') );

	my $op_and = Roma::Query::SQL::TTT::Operator->new( 'and' );
	$op_and->add( $op_eq1 );
	$op_and->add( $op_eq2 );

	my $s = generate_sql( $op_and );
	is( $s, "((column1 = 'ABC') and (column2 = '123'))" );
}

sub tttFunction1 : Test(1)
{
	my $func     = Roma::Query::SQL::TTT::Function->new( "COUNT" );
	my $ttt_join = Roma::Query::SQL::TTT::Join->new();
	$ttt_join->add( Roma::Query::SQL::TTT::Keyword->new('DISTINCT') );
	$ttt_join->add( Roma::Query::SQL::Column->new( undef, "column1" ) );
	$func->add( $ttt_join );

	my $s = generate_sql( $func );
	is( $s, 'COUNT(DISTINCT column1)' );
}

1;

