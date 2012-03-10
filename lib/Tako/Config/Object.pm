package Tako::Config::Object;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Data::Validator;
use Class::Accessor::Lite;

sub new {
    state $rule = Data::Validator->new(
        DBI       => +{ isa => 'ArrayRef' },
        time_zone => +{ isa => 'Str' },
        hash_key  => +{ isa => 'Str' }
    )->with(qw/Method/);
    my($class, $arg) = $rule->validate(@_);

    # make accessors
    Class::Accessor::Lite->mk_ro_accessors(keys %$arg);

    bless +{ %$arg } => $class;
}

1;
__END__

=head1 NAME

Tako::Config::Object - Perl extention to do something

=head1 VERSION

This document describes Tako::Config::Object version 0.01.

=head1 SYNOPSIS

    use Tako::Config::Object;
    my $config = Tako::Config::Object->new(
        DBI => [
           'DBI:SQLite:dbname=:memory:',
            '',
            '',
        ],
    );

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
