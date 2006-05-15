#!/usr/bin/perl -w

package Local::Roma::Query::XML::Where;
use base qw(Test::Class);

use Roma::Query::XML::Where;
use Roma::Driver::sqlite;
use XML::GDOME;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

sub parse
{
	my $xml = shift;
	
	my $doc = XML::GDOME->createDocFromString( $xml );
	my $op  = Roma::Query::XML::Where::create_where_from_node( $doc->getDocumentElement() );

	return $op;
}

sub xmlOperator1 : Test(1)
{
	my $xml = << "EOF";
<op:and
xmlns="http://www.carspot.com/query"
xmlns:op="http://www.carspot.com/query-operator">
	<op:equal>
		<column>column1</column>
		<literal>ABC</literal>
	</op:equal>
	<op:equal>
		<column>column2</column>
		<literal>123</literal>
	</op:equal>
</op:and>
EOF

	my $op = parse( $xml );
	my $s  = generate_sql( $op );
	is( $s, "column1 = 'ABC' AND column2 = '123'" );
}

sub xmlOperator2 : Test(1)
{
	my $xml = << "EOF";
<op:and
xmlns="http://www.carspot.com/query"
xmlns:op="http://www.carspot.com/query-operator">
	<op:equal>
		<column>column1</column>
		<literal>ABC</literal>
	</op:equal>
	<ttt op="=">
		<column>column2</column>
		<literal>123</literal>
	</ttt>
</op:and>
EOF

	my $op = parse( $xml );
	my $s  = generate_sql( $op );
	is( $s, "column1 = 'ABC' AND (column2 = '123')" );
}

1;

