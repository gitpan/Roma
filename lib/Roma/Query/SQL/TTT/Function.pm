
package Roma::Query::SQL::TTT::Function;
use base qw(Roma::Query::Function);

use Roma::Query::SQL::Column;
use Roma::Query::SQL::Literal;
use strict;

sub new
{
	my $class = shift;
	my $self  = $class->SUPER::new();

	my $name = shift;
	$self->{name} = $name;

	bless  $self, $class;
	return $self;
}

sub get_name { return shift->{name} };

sub visit
{
	my ($self, $visitor) = @_;
	return $visitor->visit_ttt_function( $self );
}

sub clone
{
	my $self = shift;

	my $clone = Roma::Query::SQL::TTT::Function->new( $self->get_name() );

	foreach my $keyword ( @{$self->get_keywords()} )
	{
		$clone->add_keyword( $keyword );
	}

	$clone->copy_arguments( $self );

	return $clone;
}

1;

