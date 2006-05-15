#!/usr/bin/perl -w

package Local::Roma::Query::Insert;
use base qw(Test::Class);

use Roma::Query::Insert;
use Roma::Query::SQL::Generate;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

=pod example

<insert into="table_name">
	<value column="column_name">
		<literal>123</literal>
	<value>
</select>

=cut
sub queryInsert1 : Test(1)
{
	my $query = Roma::Query::Insert->new( "table_name" );
	$query->set_value( 'column_name', Roma::Query::SQL::Literal->new( '123' ) );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, "INSERT INTO table_name (column_name) VALUES ('123')");
}

sub queryInsert1clone : Test(1)
{
	my $query = Roma::Query::Insert->new( "table_name" );
	$query->set_value( 'column_name', Roma::Query::SQL::Literal->new( '123' ) );
	my $clone = $query->clone();

	# generate the SQL
	my $sql = generate_sql( $clone );
	is ( $sql, "INSERT INTO table_name (column_name) VALUES ('123')");
}

1;

