package Data::Stream::Bulk::Callback;
# ABSTRACT: Callback based bulk iterator

use Moose;

use namespace::clean -except => 'meta';

with qw(Data::Stream::Bulk::DoneFlag) => { -excludes => [qw(is_done finished)] };

has callback => (
    isa => "CodeRef|Str",
    is  => "ro",
    required => 1,
    clearer  => "finished",
);

sub get_more {
    my $self = shift;
    my $cb = $self->callback;
    $self->$cb;
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__;

=pod

=head1 SYNOPSIS

    Data::Stream::Bulk::Callback->new(
        callback => sub {
            if ( @more_items = get_some() ) {
                return \@more_items;
            } else {
                return; # done
            }
        },
    }

=head1 DESCRIPTION

This class provides a callback based implementation of L<Data::Stream::Bulk>.

=attr callback

The subroutine that is called when more items are needed.

Should return an array reference for the next block, or a false value if there
is nothing left.

=method get_more

See L<Data::Stream::Bulk::DoneFlag>.

Reinvokes C<callback>.

=cut

