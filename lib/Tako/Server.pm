package Tako::Server;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Data::Validator;
use Class::Accessor::Lite (
    ro  => [
        qw/irc_host  irc_port/,
        qw/http_host http_port/,
        qw/config/
    ]
);

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
