package Tako::Plugin::Model;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Amon2::Util;
use Plack::Util;

our $BASE_NAMESPACE = 'Tako::Model';
sub init {
    my ($class, $c, $conf) = @_;

    Amon2::Util::add_method($c, 'model', sub {
        my($self, $name) = @_;

        my $class_name = "${BASE_NAMESPACE}::${name}";
        Plack::Util::load_class($class_name);
        $self->{model}{$class_name} ||= $class_name->new(
            adbh        => $self->adbh,
            driver_name => $self->driver_name,
        );
    });
}


1;
__END__

=head1 NAME

Tako::Plugin::Model - Perl extention to do something

=head1 VERSION

This document describes Tako::Plugin::Model version 0.01.

=head1 SYNOPSIS

    use Tako::Plugin::Model;

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
