package Tako::Server;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Class::Accessor::Lite (
    ro  => [
        qw/irc_host  irc_port/,
        qw/http_host http_port/,
        qw/config/
    ]
);

use AnyEvent;
use AnyEvent::CacheDNS ':register';
use Twiggy::Server;

use Log::Minimal;
use Data::Validator;

use Tako::Web;
use Tako::IRC::Server;

sub new {
    state $rule = Data::Validator->new(
        irc_host  => +{ isa => 'Str', default => '0.0.0.0' },
        irc_port  => +{ isa => 'Int', default => 6667 },
        http_host => +{ isa => 'Str', default => '0.0.0.0' },
        http_port => +{ isa => 'Int', default => 80 },
        config    => +{ isa => 'Tako::Config::Object' },
    )->with(qw/Method/);
    my($class, $arg) = $rule->validate(@_);

    bless +{ %$arg } => $class;
}

sub run {
    my $self = shift;

    my $cv = AnyEvent->condvar;

    my $twg  = $self->create_webserver;
    my $ircd = $self->create_irc_proxy;

    $cv->recv;
}

sub create_webserver {
    my $self = shift;

    my $twg = Twiggy::Server->new(
        host => $self->http_host,
        port => $self->http_port,
    );
    my $app = Tako::Web->to_app(config => $self->config);
    $twg->register_service($app);
    infof('Web interface is here: http://%s:%s/', $self->http_host, $self->http_port);

    return $twg;
}

sub create_irc_proxy {
    my $self = shift;

    my $ircd = Tako::IRC::Server->new(
        host   => $self->irc_host,
        port   => $self->irc_port,
        config => $self->config,
    );
    $ircd->run;
    infof('IRC interface is here: http://%s:%s/', $self->irc_host, $self->irc_port);

    return $ircd;
}

1;
__END__

=head1 NAME

Tako::Server - Perl extention to do something

=head1 VERSION

This document describes Tako::Server version 0.01.

=head1 SYNOPSIS

    use Tako::Server;
    use Tako::Config;

    my $config = Tako::Config->load(file => 'config.yaml');
    Tako::Server->new(
        irc_host  => '0.0.0.0',
        irc_port  => 6667,
        http_host => '127.0.0.1',
        http_port => 8080,
        config    => $config,
    )->run;

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
