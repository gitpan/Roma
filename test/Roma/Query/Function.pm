#!/usr/bin/perl -w

package Local::Roma::Query::Function;
use base qw(Test::Class);

use Roma::Query::Function::Count;
use Roma::Query::Function::Now;
use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use Roma::Driver::sqlite;
use Test::More;
use strict;

use Data::Dumper;

# utility function makes SQL out of whatever
sub generate_sql { return Roma::Driver::sqlite->new()->generate_sql( @_ ) };

sub functionCount : Test(1)
{
	my $count = Roma::Query::Function::Count->new();
	$count->set_distinct( 1 );
	$count->add( Roma::Query::SQL::Column->new( undef, 'column_name' ) );

	my $s = generate_sql( $count );
	is( $s, "COUNT(DISTINCT column_name)" );
}

sub functionNow : Test(1)
{
	my $count = Roma::Query::Function::Now->new();

	my $s = generate_sql( $count );
	is( $s, "NOW()" );
}

1;

