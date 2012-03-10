package Tako::Web;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use parent qw/Tako Amon2::Web/;
use Tako::Web::Dispatcher;
use Tako::Web::Middleware;

# dispatcher
sub dispatch {
    return Tako::Web::Dispatcher->dispatch($_[0]) or die "response is not generated";
}

sub to_app {
    my $class = shift;
    $class->new(@_)->setup_schema if (@_);

    my $app = $class->SUPER::to_app;
    return Tako::Web::Middleware->wrap($app);
}

sub base_url {
    my($self, $scheme) = @_;

    my $base = $self->_base_url;
    $base = $base->clone->scheme($scheme) if $scheme;

    return $base->as_string;
}

sub _base_url {
    my $self = shift;

    $self->{_base_url} ||= $self->req->base;
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::CSRFDefender',
    '+Tako::Plugin::Web::Xslate',
);

1;
__END__

=head1 NAME

Tako::Web - Perl extention to do something

=head1 VERSION

This document describes Tako::Web version 0.01.

=head1 SYNOPSIS

    use Tako::Web;
    Tako::Web->to_app;

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
