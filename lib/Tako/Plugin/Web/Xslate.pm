package Tako::Plugin::Web::Xslate;
use 5.010_000;
use strict;
use warnings;
use utf8;

use Amon2;
use Amon2::Util;
use Tako::Util;
use Text::Xslate;

our $VERSION = '0.01';

sub init {
    my ($class, $c, $conf) = @_;

    my $xslate = Text::Xslate->new($class->config);
    Amon2::Util::add_method($c, 'create_view', sub { $xslate });
}

sub config {
    +{
        function => {
            c        => sub { Amon2->context() },
            uri_with => sub { Amon2->context()->req->uri_with(@_) },
            uri_for  => sub { Amon2->context()->uri_for(@_) },
            base_url => sub { Amon2->context()->base_url(@_) }
        },
        path   => [ Tako::Util::get_path('tmpl') ],
        suffix => '.html',
    }
}

1;
__END__

=head1 NAME

Tako::Plugin::Web::Xslate - Perl extention to do something

=head1 VERSION

This document describes Tako::Plugin::Web::Xslate version 0.01.

=head1 SYNOPSIS

    package Hoge::Web;
    use strict;
    use warnings;
    use utf8;

    use parent qw/Hoge Amon2::Web/;

    __PACKAGE__->load_plugins(qw/+Tako::Plugin::Web::Xslate/);

    1;

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
