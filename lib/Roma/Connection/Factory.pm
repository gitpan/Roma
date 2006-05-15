
package Roma::Connection::Factory;

use Roma::Connection;
use DBI;
use strict;

sub new
{
	my $class = shift;
	my $args  = shift;

	my $dbh;
	my $dsn;
	my $driver;

	if ( ref($args) eq 'HASH' )
	{
		$dbh = $args->{dbh};
		$dsn = $args->{dsn};
		$driver = $args->{driver};
	}

	if ( not defined $dbh and not defined $dsn )
	{
		# Programmer error
		die "Must defined either a dsn or dbh";
	}
	if ( defined $dsn and defined $dbh )
	{
		# Programmer error
		die "Cannot defined both a dsn and dbh";
	}
	if ( not defined $driver )
	{
		# Programmer error
		die "Must define the connection driver";
	}

	my $self = {
		dbh => $dbh,
		dsn => $dsn,
		driver => $driver
	};

	bless  $self, $class;
	return $self;
}

sub create
{
	my $self = shift;

	my $conn;

	if ( $self->{dbh} )
	{
		$conn = Roma::Connection->new({ dbh => $self->{dbh}, driver => $self->{driver}, disconnect => 0 });
	}
	else
	{
		my $dbh = DBI->connect( $self->{dsn} );
		$conn = Roma::Connection->new({ dbh => $dbh, driver => $self->{driver}, disconnect => 1 });
	}

	return $conn;
}

sub DESTROY
{
	my $self = shift;

	if ( $self->{dbh} )
	{
		$self->{dbh}->disconnect();
		$self->{dbh} = undef;
	}
}

1;

