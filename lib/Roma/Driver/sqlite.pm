
package Roma::Driver::sqlite;
use base qw(Roma::Driver);

use Roma::Driver::sqlite::IdGenerator;
use strict;

# TODO: this function will take a "Roma-style" DSN or hash, and make
# a DBI connection returning a dbh.
sub connect_dbi
{
	die "Unimplemented.";
}

sub apply_limit
{
	my ($self, $sql, $offset, $limit) = @_;

	if ( $limit > 0 )
	{
		$sql .= " LIMIT " . $limit;
		if ( $offset > 0 )
		{
			$sql .= " OFFSET " . $offset;
		}
	}
	elsif ( $offset > 0 )
	{
		$sql .= " LIMIT -1 OFFSET " . $offset;
	}

	return $sql;
}

sub create_id_generator
{
	my ($self, $conn) = @_;
	return Roma::Driver::sqlite::IdGenerator->new( $conn );
}

1;

