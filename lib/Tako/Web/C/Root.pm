package Tako::Web::C::Root;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

sub index {
    my ($class, $c) = @_;

    return $c->render('root/index.html' => {});
}

1;
__END__

=head1 NAME

Tako::Web::C::Root - Perl extention to do something

=head1 VERSION

This document describes Tako::Web::C::Root version 0.01.

=head1 SYNOPSIS

    use Tako::Web::C::Root;

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
