
package Roma::Query::XML::SQL;

use Roma::Query::XML::Util;
use Roma::Query::XML::TTT;
use Roma::Query::XML::Where;
use Roma::Query::XML::Function;
use Roma::Query::Function::Count;
use strict;

use Data::Dumper;

sub create_value_from_node
{
	my $node = shift;

	if ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY )
	{
		if ( $node->getTagName() eq 'ttt' )
		{
			if ( Roma::Query::XML::TTT::get_node_type( $node ) eq 'func' )
			{
				return Roma::Query::XML::TTT::create_ttt_from_node( $node );
			}
		}
		elsif ( $node->getTagName() eq 'literal' )
		{
			return Roma::Query::SQL::Literal->new( Roma::Query::XML::Util::get_text( $node ) );
		}
		elsif ( $node->getTagName() eq 'column' )
		{
			# TODO: we should be able to set the table name
			return Roma::Query::SQL::Column->new( undef, Roma::Query::XML::Util::get_text( $node ) );
		}
	}
	elsif ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY_FUNCTION )
	{
		return Roma::Query::XML::Function::create_function_from_node( $node );
	}

	# Not a valid value!
	return undef;
}

sub create_function_from_node
{
	my $node = shift;

	if ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY )
	{
		if ( $node->getTagName() eq 'ttt' )
		{
			if ( Roma::Query::XML::TTT::get_node_type( $node ) eq 'func' )
			{
				return Roma::Query::XML::TTT::create_ttt_from_node( $node );
			}
		}
	}
	elsif ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY_FUNCTION )
	{
		return Roma::Query::XML::Function::create_function_from_node( $node );
	}

	return undef;
}

sub create_where_from_node
{
	my $node = shift;

	if ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY and 
	     $node->getTagName() eq 'ttt' )
	{
		return Roma::Query::XML::TTT::create_ttt_from_node( $node );
	}
	elsif ( $node->getNamespaceURI() eq $Roma::Query::XML::Util::NS_QUERY_OPERATOR )
	{
		return Roma::Query::XML::Where::create_where_from_node( $node );
	}
	else
	{
		# if it is not any type of operator, it must be a value!
		return create_value_from_node( $node );
	}
}

1;

