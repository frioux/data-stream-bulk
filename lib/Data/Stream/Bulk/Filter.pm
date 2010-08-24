package Data::Stream::Bulk::Filter;
# ABSTRACT: Streamed filtering (block oriented)

use Moose;

use Data::Stream::Bulk;

use namespace::clean -except => 'meta';

has filter => (
    isa => "CodeRef",
    reader => "filter_body",
    required => 1,
);

has stream => (
    does => "Data::Stream::Bulk",
    is   => "ro",
    required => 1,
    handles  => [qw(is_done loaded)],
);

with qw(Data::Stream::Bulk) => { -excludes => 'loaded' };

sub next {
    my $self = shift;

    local $_ = $self->stream->next;
    return $_ && ( $self->filter_body->($_) || [] );
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__;

=pod

=head1 SYNOPSIS

    use Data::Stream::Bulk::Filter;

    Data::Stream::Bulk::Filter->new(
        filter => sub { ... },
        stream => $stream,
    );

=head1 DESCRIPTION

This class implements filtering of streams.

=attr filter

The code reference to apply to each block.

The block is passed to the filter both in C<$_> and as the first argument.

The return value should be an array reference. If no true value is returned the
output stream does B<not> end, but instead an empty block is substituted (the
parent stream controls when the stream is depleted).

=attr stream

The stream to be filtered

=method is_done

=method loaded

Delegated to C<stream>

=method next

Calls C<next> on C<stream> and applies C<filter> if a block was returned.

=cut
