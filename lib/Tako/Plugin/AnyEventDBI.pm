package Tako::Plugin::AnyEventDBI;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Amon2::Util;
use DBI;
use AnyEvent::DBI;

sub init {
    my ($class, $c, $conf) = @_;

    Amon2::Util::add_method($c, 'adbh', sub {
        my $self = shift;
        $self->{$class} ||= $self->create_adbh;
    });
    Amon2::Util::add_method($c, 'driver_name', sub {
        my $self = shift;
        $self->{driver_name} ||= (DBI->parse_dsn($self->config->{DBI}[0]))[1];
    });
    Amon2::Util::add_method($c, 'create_adbh', \&_create_adbh);
}

sub _create_adbh {
    my $self = shift;

    AnyEvent::DBI->new(@{ $self->config->{DBI} });
}

1;
__END__

=head1 NAME

Tako::Plugin::AnyEventDBI - Perl extention to do something

=head1 VERSION

This document describes Tako::Plugin::AnyEventDBI version 0.01.

=head1 SYNOPSIS

    use Tako::Plugin::AnyEventDBI;

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
