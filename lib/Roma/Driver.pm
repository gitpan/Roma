
package Roma::Driver;

use Roma::PreparedStatement;
use Roma::ResultSet;
use Roma::Query::SQL::Generate;
use strict;

sub new
{
	return bless {}, shift;
}

sub connect_dbi
{
	die "Abstract.";
}

sub apply_limit
{
	die "Abstract.";
}

sub create_id_generator
{
	die "Abstract.";
}

sub create_prepared_statement
{
	my ($self, $conn, $sql) = @_;
	return Roma::PreparedStatement->new( $conn, $sql );
}

sub create_result_set
{
	my ($self, $conn, $sth, $fetchmode) = @_;
	return Roma::ResultSet->new( $conn, $sth, $fetchmode );
}

sub escape_string
{
	my ($self, $s) = @_;

	$s =~ s/'/''/g;

	return $s;
}

sub generate_sql
{
	my $self = shift;
	my $args = shift;

	my $query;
	my $values;

	if ( ref($self) eq 'HASH' )
	{
		$query  = $args->{query};
		$values = $args->{values};
	}
	else
	{
		$query  = $args;
		$values = shift;
	}

	my $generator = Roma::Query::SQL::Generate->new({ driver => $self, values => $values });
	
	return $query->visit( $generator );
}

1;

