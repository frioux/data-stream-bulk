package Data::Stream::Bulk::FileHandle;
use Moo;
# ABSTRACT: read lines from a filehandle

use Types::Standard 'FileHandle';

use namespace::clean -except => 'meta';

use IO::Handle;

with 'Data::Stream::Bulk::DoneFlag';

has filehandle => (
    is       => 'ro',
    isa      => FileHandle,
    required => 1,
);

sub get_more {
    my $self = shift;

    my $line = $self->filehandle->getline;
    return unless defined $line;
    return [ $line ];
}

=head1 SYNOPSIS

  use Data::Stream::Bulk::FileHandle;
  use Path::Class;

  my $s = Data::Stream::Bulk::FileHandle->new(
      filehandle => file('foo.txt')->openr,
  );

=head1 DESCRIPTION

This provides a stream API for reading lines from a file.

=head1 ATTRIBUTES

=over 4

=item filehandle

A file handle that has been opened for reading. The stream will return lines
from this file, one by one.

=back

=head1 METHODS

=over 4

=item get_more

See L<Data::Stream::Bulk::DoneFlag>.

Returns the next line from the file, if it exists.

=back

=cut

1;
