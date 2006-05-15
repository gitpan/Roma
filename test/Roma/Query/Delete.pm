#!/usr/bin/perl -w

package Local::Roma::Query::Delete;
use base qw(Test::Class);

use Roma::Query::Delete;
use Roma::Query::SQL::Generate;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

=pod example

<delete from="table_name">
	<where>
		<op:equal>
			<column>id</column>
			<literal>0</literal>
		</op:equal>
	</where>
</select>

=cut
sub queryDelete1 : Test(1)
{
	my $query = Roma::Query::Delete->new( "table_name" );
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'id' ) );
	$equal->add( Roma::Query::SQL::Literal->new( '0' ) );
	$query->set_where( $equal );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, "DELETE FROM table_name WHERE id = '0'" );
}

sub queryDelete1clone : Test(1)
{
	my $query = Roma::Query::Delete->new( "table_name" );
	my $equal = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$equal->add( Roma::Query::SQL::Column->new( undef, 'id' ) );
	$equal->add( Roma::Query::SQL::Literal->new( '0' ) );
	$query->set_where( $equal );
	my $clone = $query->clone();

	# generate the SQL
	my $sql = generate_sql( $clone );
	is ( $sql, "DELETE FROM table_name WHERE id = '0'" );
}

1;

