package Tako::Model::User;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use parent qw/Tako::Model/;

use Data::Validator;
use Scalar::Util qw/weaken/;
use Tako::Util;

sub table_name { 'user' }
sub fields     { [qw/id login_name password created_at updated_at/] }

sub register {
    state $rule = Data::Validator->new(
        login_name => +{ isa => 'Str'     },
        password   => +{ isa => 'Str'     },
        on_success => +{ isa => 'CodeRef' },
        on_error   => +{ isa => 'CodeRef' }
    )->with(qw/Method/);
    my($self, $arg) = $rule->validate(@_);

    my $login_name = $arg->{login_name};
    my $password   = Tako::Util::to_hash($arg->{password});
    my $on_success = $arg->{on_success};
    my $on_error   = $arg->{on_error};

    weaken($self);
    $self->select(
        +{
            login_name => $login_name
        },
        sub {
            my($rows) = @_;

            if (not @$rows) {
                $self->insert(
                    +{
                        login_name => $login_name,
                        password   => $password,
                        created_at => $self->now_datetime,
                    },
                    sub {
                        my($adbh, $rows, $rv) = @_;
                        $self->$on_success;
                    },
                );
            }
            else {
                $self->$on_error;
            }
        }
    );
}

1;
__END__

=head1 NAME

Tako::Model::User - Perl extention to do something

=head1 VERSION

This document describes Tako::Model::User version 0.01.

=head1 SYNOPSIS

    use Tako::Model::User;

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
