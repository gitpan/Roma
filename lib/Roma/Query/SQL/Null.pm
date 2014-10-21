
package Roma::Query::SQL::Null;

sub new
{
	return bless { }, shift;
}

sub visit
{
	my ($self, $visitor) = @_;
	return $visitor->visit_null( $self );
}

sub clone
{
	return Roma::Query::SQL::Null->new();
}

1;

