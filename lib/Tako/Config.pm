package Tako::Config;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Tako::Exception;
use Tako::Config::Object;

use YAML::Syck ();
use Data::Validator;
use Log::Minimal;
use Try::Tiny;

sub load {
    state $rule = Data::Validator->new(
        file => +{ isa => 'Str' }
    )->with(qw/Method/);
    my($class, $arg) = $rule->validate(@_);

    Tako::Exception::Config::FileNotFound->throw(file => $arg->{file}) unless -f $arg->{file};

    local $YAML::Syck::ImplicitUnicode = 1;
    my $config = try {
        YAML::Syck::LoadFile($arg->{file});
    }
    catch {
        my $e = $_;

        Tako::Exception::Config::CannnotReadFile->throw(
            file  => $arg->{file},
            error => $e,
        );
    };

    return Tako::Config::Object->new($config);
}

1;
__END__

=head1 NAME

Tako::Config - Perl extention to do something

=head1 VERSION

This document describes Tako::Config version 0.01.

=head1 SYNOPSIS

    use Tako::Config;

    my $config = Tako::Config->load('config.yaml');

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
