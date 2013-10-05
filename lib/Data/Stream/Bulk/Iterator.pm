package Data::Stream::Bulk::Iterator;
use Moose;

has stream => (
    does     => "Data::Stream::Bulk",
    is       => "ro",
    required => 1,
    handles  => [qw(is_done loaded)],
);

with qw(Data::Stream::Bulk) => { -excludes => 'loaded' };

has block => (
    isa       => 'ArrayRef',
    predicate => 'has_block',
    clearer   => 'next_block',
    traits    => ['Array'],
    lazy      => 1,
    default   => sub {
        shift->stream->next || []
    },
    handles => {
        block_size         => 'count',
        next_block_element => 'shift',
    }
);

sub next {
    my $self = shift;
    unless ( $self->has_block && $self->block_size ) {
        $self->next_block;
    }
    return $self->next_block_element
        if !$self->is_done && $self->block_size;
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__;

__END__
