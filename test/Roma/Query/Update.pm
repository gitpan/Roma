#!/usr/bin/perl -w

package Local::Roma::Query::Update;
use base qw(Test::Class);

use Roma::Query::Update;
use Roma::Query::SQL::Generate;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Query::Comparison;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

=pod example

<update table="table_name">
	<value column="column_name">
		<literal>123</literal>
	<value>

	<where>
		<op:equal>
			<column>id</column>
			<literal>0</literal>
		</op:equal>
	</where>
</select>

=cut
sub queryUpdate1 : Test(1)
{
	my $query = Roma::Query::Update->new( "table_name" );
	$query->set_value( 'column_name', Roma::Query::SQL::Literal->new( '123' ) );
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'id' ) );
	$equal->add( Roma::Query::SQL::Literal->new( '0' ) );
	$query->set_where( $equal );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, "UPDATE table_name SET column_name = '123' WHERE id = '0'" );
}

sub queryUpdate1clone : Test(1)
{
	my $query = Roma::Query::Update->new( "table_name" );
	$query->set_value( 'column_name', Roma::Query::SQL::Literal->new( '123' ) );
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'id' ) );
	$equal->add( Roma::Query::SQL::Literal->new( '0' ) );
	$query->set_where( $equal );
	my $clone = $query->clone();

	# generate the SQL
	my $sql = generate_sql( $clone );
	is ( $sql, "UPDATE table_name SET column_name = '123' WHERE id = '0'" );
}

1;

