package Data::Stream::Bulk::Nil;
# ABSTRACT: An empty L<Data::Stream::Bulk> iterator

use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk) => { -excludes => [qw/loaded filter list_cat all items/] };

sub items { return () }

sub all { return () }

sub next { undef }

sub is_done { 1 }

sub list_cat {
    my ( $self, $head, @rest ) = @_;

    return () unless $head;
    return $head->list_cat(@rest);
}

sub filter { return $_[0] };

sub loaded { 1 }

__PACKAGE__->meta->make_immutable;

__PACKAGE__;

=pod

=head1 SYNOPSIS

    return Data::Stream::Bulk::Nil->new; # empty set

=head1 DESCRIPTION

This iterator can be used to return the empty resultset.

=method is_done

Always returns true.

=method next

Always returns undef.

=method items

=method all

Always returns the empty list.

=method list_cat

Skips $self

=method filter

Returns $self

=method loaded

Returns true.

=cut
