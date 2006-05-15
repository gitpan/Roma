
package Roma::Query::XML::Where;

use Roma::Query::XML::Util;
use Roma::Query::XML::SQL;
use Roma::Query::Comparison;
use Roma::Query::Where;
use XML::DOM;
use strict;

use Data::Dumper;

sub create_where_from_node
{
	my $op_node = shift;

	my $name   = $op_node->getLocalName();
	my $ns_uri = $op_node->getNamespaceURI();

	my $op;

	# create the actual object
	if ( $ns_uri eq $Roma::Query::XML::Util::NS_QUERY_OPERATOR )
	{
		if ( $name eq 'and' )
		{
			$op = Roma::Query::Where->new( $Roma::Query::Where::AND );
		}
		elsif ( $name eq 'equal' )
		{
			$op = Roma::Query::Comparison->new( $Roma::Query::Comparison::EQUAL );
		}
	}

	if ( not defined $op )
	{
		die "Unknown operator \"$ns_uri\" \"$name\"";
	}

	# go through the children
	my $node = $op_node->getFirstChild();
	while ( defined $node )
	{
		if ( $node->getNodeType() == XML::DOM::ELEMENT_NODE )
		{
			# operators can hold other things regarded as where
			$op->add( Roma::Query::XML::SQL::create_where_from_node($node) );
		}

		$node = $node->getNextSibling();
	}

	return $op;
}

1;

