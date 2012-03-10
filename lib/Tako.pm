package Tako;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use parent qw/Amon2/;
use Tako::Util;

use Class::Accessor::Lite (
    ro => [qw/config/],
);

sub load_config { require Carp; Carp::croak('this is abolitioned method.') }

# initialize database
sub setup_schema {
    my $self = shift;
    my $dbh = $self->dbh;
    my $driver_name = $dbh->{Driver}->{Name};

    my $fname = Tako::Util::get_path(sql => "${driver_name}.sql");

    my $source = do {# read from scheme file
        open my $fh, '<:encoding(UTF-8)', $fname or die "$fname: $!";
        my $buf = do { local $/; <$fh> };
        close($fh);
        $buf;
    };

    for my $stmt (split ';', $source) {
        next unless $stmt =~ /\S/;
        $dbh->do($stmt) or die $dbh->errstr;
    }
}

__PACKAGE__->load_plugins(
    '+Tako::Plugin::DBI',
);

1;
__END__

=head1 NAME

Tako - Perl extention to do something

=head1 VERSION

This document describes Tako version 0.01.

=head1 SYNOPSIS

    use Tako;

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
