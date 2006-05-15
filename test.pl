#/usr/bin/perl -w

use test::Roma::Query::Select;
use test::Roma::Query::SQL::TTT;
use test::Roma::Query::Comparison;
use test::Roma::Query::Function;
use test::Roma::Query::XML::Select;
use test::Roma::Query::XML::TTT;
use test::Roma::Query::XML::Where;
use test::Roma::Query::XML::Function;
use test::Roma::Query::Insert;
use test::Roma::Query::Update;
use test::Roma::Query::Delete;
use test::Roma::Driver::sqlite;

use Carp;

$SIG{__DIE__} = sub {
	Carp::confess(@_);
	#Carp::confess;
};

if ( @ARGV > 0 )
{
	my @spec;

	foreach my $s ( @ARGV )
	{
		my @t = split('::', $s);
		unshift @t, "Local";
		push @spec, join('::', @t);
	}

	Test::Class->runtests( @spec );
}
else
{
	# run 'em all!
	Test::Class->runtests;
}

