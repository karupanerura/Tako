package Tako::Runner;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use Tako;
use Tako::Server;
use Tako::Config;

use Getopt::Long ();
use File::Basename ();
use Config ();
use Pod::Usage ();
use Class::Accessor::Lite (
    ro => [
        qw/argv getopt_failed/,
        qw/config_file logfile irc_host irc_port http_host http_port/,# options
        qw/version help/# flags
    ]
);

sub getopt_spec {
    return(
        'config_file=s',
        'logfile=s',
        'http_host=s',
        'http_port=i',
        'irc_host=s',
        'irc_port=i',
        'version',
        'help',
    );
}

sub getopt_parser {
    return Getopt::Long::Parser->new(
        config => [qw(
            no_ignore_case
            bundling
            no_auto_abbrev
        )],
    );
}

sub appname { 'tako' }

sub new {
    my $class = shift;
    local @ARGV = @_;

    my %opts;
    my $success = $class->getopt_parser->getoptions(
        \%opts,
        $class->getopt_spec
    );

    if(!$success) {
        $opts{help}++;
        $opts{getopt_failed}++;
    }

    $opts{argv} = \@ARGV;

    return bless \%opts, $class;
}

sub run {
    my $self = shift;

    if ($self->help) {
        $self->do_help;
    }
    elsif ($self->version) {
        $self->do_version;
    }
    else {
        $self->dispatch(@ARGV);
    }

    return;
}

sub dispatch {
    my($self, @args) = @_;

    my $config = Tako::Config->load(file => $self->config_file);
    Tako::Server->new(
        config    => $config,
        $self->irc_host  ? (irc_host  => $self->irc_host)  : (),
        $self->irc_port  ? (irc_port  => $self->irc_port)  : (),
        $self->http_host ? (http_host => $self->http_host) : (),
        $self->http_port ? (http_port => $self->http_port) : (),
    )->run;
}

sub do_help {
    my($self) = @_;
    if ($self->getopt_failed) {
        die $self->help_message;
    }
    else {
        print $self->help_message;
    }
}

sub do_version {
    my($self) = @_;
    print $self->version_message;
}

sub help_message {
    my($self) = @_;

    open my $fh, '>', \my $buffer;
    Pod::Usage::pod2usage(
        -message => $self->version_message,
        -exitval => 'noexit',
        -output  => $fh,
        -input   => __FILE__,
    );
    close $fh;
    return $buffer;
}

sub version_message {
    my($self) = @_;

    return sprintf "%s\n" . "\t%s/%s\n" . "\tperl/%vd on %s\n",
        $self->appname, 'Tako', $Tako::VERSION,
        $^V, $Config::Config{archname};
}

1;
__END__

=head1 NAME

Tako::Runner - Perl extention to do something

=head1 VERSION

This document describes Tako::Runner version 0.01.

=head1 SYNOPSIS

    $ tako --config_file tako.yaml --http_port 8080

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
