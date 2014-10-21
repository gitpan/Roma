#!/usr/bin/perl -w

package Local::Roma::Query::Select;
use base qw(Test::Class);

use Roma::Query::Select;
use Roma::Query::Comparison;
use Roma::Query::SQL::Generate;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::TTT::Function;
use Roma::Query::SQL::TTT::Keyword;
use Roma::Query::SQL::TTT::Join;
use Roma::Query::Function::Count;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

=pod example

<select from="table_name">
	<result>
		<column>column_name</column>
	</result>
</select>

=cut
sub querySelect1 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT column_name FROM table_name');
}

=pod example

<select from="table_name">
	<result>
		<column as="alias_name" table="table_name">column_name</column>
	</result>
</select>

=cut
sub querySelect2 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new("table_name", "column_name"), "alias_name" );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT table_name.column_name AS alias_name FROM table_name');
}

=pod example

<select from="table_name">
	<result>
		<expr as="count">
			<ttt func="COUNT">
				<ttt keyword="DISTINCT"/>
				<column>column_name</column>
			</ttt>
		</expr>
	</result>
</select>

=cut
sub querySelect3 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );

	my $count_func = Roma::Query::SQL::TTT::Function->new( "COUNT" );
	my $ttt_join   = Roma::Query::SQL::TTT::Join->new();
	$ttt_join->add( Roma::Query::SQL::TTT::Keyword->new('DISTINCT') );
	$ttt_join->add( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$count_func->add( $ttt_join );

	$query->add_result({ value => $count_func, as => "count" });
	
	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT COUNT(DISTINCT column_name) AS count FROM table_name');
}

=pod example

<select from="table_name">
	<result>
		<expr as="count">
			<count distinct="true">
				<column>column_name</column>
			</count>
		</expr>
	</result>
</select>

=cut
sub querySelect4 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );

	my $count_func = Roma::Query::Function::Count->new( "COUNT" );
	$count_func->set_distinct( 1 );
	$count_func->add( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$query->add_result({ value => $count_func, as => "count" });
	
	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT COUNT(DISTINCT column_name) AS count FROM table_name');
}

=pod example

<select from="table_name">
	<result>
		<column>column_name</column>
	</result>
	<where>
		<ttt op="=">
			<column>column_name</column>
			<literal>123</literal>
		</ttt>
	</where>
</select>

=cut
sub querySelect5 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );

	my $where = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$where->add( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$where->add( Roma::Query::SQL::Literal->new( "123" ) );
	$query->set_where( $where );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, "SELECT column_name FROM table_name WHERE column_name = '123'");
}

=pod example

<select from="table_name">
	<result>
		<column>column_name</column>
	</result>
	<group-by column="column2"/>
</select>

=cut
sub querySelect6 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$query->add_group_by( Roma::Query::SQL::Column->new( undef, "column2" ) );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT column_name FROM table_name GROUP BY column2');
}

=pod example

<select from="table_name">
	<result>
		<column>column_name</column>
	</result>
	<order-by column="column2" dir="asc"/>
</select>

=cut
sub querySelect7 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$query->add_order_by( Roma::Query::SQL::Column->new( undef, "column2" ), "asc" );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT column_name FROM table_name ORDER BY column2 ASC');
}

=pod example

<select from="table1"
xmlns="http://www.carspot.com/query"
xmlns:op="http://www.carspot.com/query-operator">
	<result>
		<column>column_name</column>
	</result>
	<join type="inner" table="table2">
		<op:equal>
			<column>table1.key</column>
			<column>table2.table1_key</column>
		</op:equal>
	</join>
</select>

=cut
sub querySelect8 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table1" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );

	my $eq_op = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
	$eq_op->add( Roma::Query::SQL::Column->new( 'table1', 'key' ) );
	$eq_op->add( Roma::Query::SQL::Column->new( 'table2', 'table1_key' ) );
	$query->set_join({ type => 'inner', table => 'table2', on => $eq_op });

	# generate the SQL
	my $sql = generate_sql( $query );
	is ($sql, 'SELECT column_name FROM table1 INNER JOIN table2 ON table1.key = table2.table1_key');
}

=pod example

<select from="table_name" limit="10" offset="20">
	<result>
		<column>column_name</column>
	</result>
</select>

=cut
sub querySelect9 : Test(1)
{
	my $query = Roma::Query::Select->new();
	$query->add_from( "table_name" );
	$query->add_result( Roma::Query::SQL::Column->new( undef, "column_name" ) );
	$query->set_limit( 10, 20 );

	# generate the SQL
	my $sql = generate_sql( $query );
	is ( $sql, 'SELECT column_name FROM table_name LIMIT 10 OFFSET 20');
}

1;

