package Tako::Exception;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use overload (
    '""'     => sub { shift->msg },
    fallback => 1,
);

use Class::Accessor::Lite (
    new => 1,
    ro  => [qw/exception/]
);

sub throw  {
    my $class = shift;

    die $class->new(@_, exception => $class);
}
sub msg { +shift->exception }

package Tako::Exception::Config;
use strict;
use warnings;
use utf8;
use parent -norequire, qw/Tako::Exception/;

use Class::Accessor::Lite (
    ro => [qw/file/]
);

package Tako::Exception::Config::FileNotFound;
use strict;
use warnings;
use utf8;
use parent -norequire, qw/Tako::Exception::Config/;

sub msg {
    my $self = shift;

    "config file '@{[ $self->file ]}' not found.";
}

package Tako::Exception::Config::CannnotReadFile;
use strict;
use warnings;
use utf8;
use parent -norequire, qw/Tako::Exception::Config/;
use Class::Accessor::Lite ro => [qw/error/];

sub msg {
    my $self = shift;

    "config file '@{[ $self->file ]}' cannot read. ERROR: '@{[ $self->error ]}'";
}

1;
__END__

=head1 NAME

Tako::Exception - Perl extention to do something

=head1 VERSION

This document describes Tako::Exception version 0.01.

=head1 SYNOPSIS

    use Tako::Exception;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Kenta Sato E<lt>karupa@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Kenta Sato. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
