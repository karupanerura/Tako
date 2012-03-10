package Tako::Model;
use 5.010_000;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Class::Accessor::Lite (
    ro => [qw/adbh driver_name/],
);
use SQL::Maker;
use Data::Validator;
use Tako::Util;
use Tako::Exception;
use Scalar::Util qw/weaken/;

sub new {
    state $rule = Data::Validator->new(
        adbh        => +{ isa => 'AnyEvent::DBI' },
        driver_name => +{ isa => 'Str'           }
    )->with(qw/Method/);
    my($class, $arg) = $rule->validate(@_);

    bless +{ %$arg } => $class;
}

sub builder {
    state $cache = +{};
    my $self = shift;

    $cache->{$self->driver_name} ||=  SQL::Maker->new(
        driver => $self->driver_name
    );
}

sub table_name { require Carp; Carp::croak 'this is abstruct method' }
sub fields     { require Carp; Carp::croak 'this is abstruct method' }

*search = *select;
sub select {
    state $rule = Data::Validator->new(
        undef  => +{ isa => 'Any' },
        where  => +{ isa => 'HashRef' },
        opt    => +{ isa => 'HashRef', optional => 1 },
    )->with(qw/StrictSequenced/);
    my $self = shift;
    my $cb   = pop;
    my $arg  = $rule->validate(undef, @_);

    my $fields =
        (exists($arg->{opt}) and exists($arg->{opt}{select})) ?
            $arg->{opt}{select}:
            $self->fields;

    my($sql, @binds) = $self->builder->select(
        $self->table_name,
        $fields,
        $arg->{where},
        exists($arg->{opt}) ? $arg->{opt} : ()
    );

    weaken($self);
    $self->adbh->exec($sql, @binds, sub {
        my(undef, $rows) = @_;
        $rows = $self->format_response(
            rows   => $rows,
            fields => $fields,
        );
        $cb->($rows)
    });
}

sub insert {
    state $rule = Data::Validator->new(
        values => +{ isa => 'HashRef' },
        cb     => +{ isa => 'CodeRef', optional => 1 }
    )->with(qw/Method StrictSequenced/);
    my($self, $arg) = $rule->validate(@_);

    my $cb = exists($arg->{cb}) ? $arg->{cb} : sub {};
    my $now_datetime = $self->now_datetime;
    my($sql, @binds) = $self->builder->insert($self->table_name, +{
        created_at => $now_datetime,
        updated_at => $now_datetime,
        %{ $arg->{values} },
    });

    $self->adbh->exec($sql, @binds, $cb);
}

sub update {
    state $rule = Data::Validator->new(
        values => +{ isa => 'HashRef' },
        where  => +{ isa => 'HashRef' },
        cb     => +{ isa => 'CodeRef', optional => 1 },
    )->with(qw/StrictSequenced/);
    my($self, $arg) = $rule->validate(@_);

    my $cb = exists($arg->{cb}) ? $arg->{cb} : sub {};
    my($sql, @binds) = $self->builder->update($self->table_name,  +{
        updated_at => $self->now_datetime,
        %{ $arg->{values} },
    }, $arg->{where});

    $self->adbh->exec($sql, @binds, $cb);
}

sub delete {
    state $rule = Data::Validator->new(
        where => +{ isa => 'HashRef' },
        cb    => +{ isa => 'CodeRef', optional => 1 }
    )->with(qw/Method StrictSequenced/);
    my($self, $arg) = $rule->validate(@_);

    my $cb = exists($arg->{cb}) ? $arg->{cb} : sub {};
    my($sql, @binds) = $self->builder->delete($self->table_name, $arg->{where});

    $self->adbh->exec($sql, @binds, $cb);
}

sub format_response {
    state $rule = Data::Validator->new(
        fields => +{ isa => 'ArrayRef[Str]' },
        rows   => +{ isa => 'ArrayRef[ArrayRef[Str]]' },
    )->with(qw/Method/);
    my($self, $arg) = $rule->validate(@_);

    my @formated_rows;
    foreach my $row (@{ $arg->{rows} }) {
        my %data;
        foreach my $i (0 .. $#{ $arg->{fields} }) {
            $data{$arg->{fields}[$i]} = $row->[$i];
        }
        push @formated_rows => \%data;
    }

    return \@formated_rows;
}

sub now_datetime {
    state $datetime_fmt = +{
        mysql  => '%Y-%m-%d %H:%M:%S',
        sqlite => '%Y-%m-%d %H:%M:%S'
    };
    my $self = shift;
    my $fmt  = $datetime_fmt->{lc($self->driver_name)} or Tako::Exception::Model::UnsupportedDriver->throw(
        driver_name => $self->driver_name,
    );

    return Tako::Util::strftime($fmt, time);
}

1;
__END__

=head1 NAME

Tako::Model - Perl extention to do something

=head1 VERSION

This document describes Tako::Model version 0.01.

=head1 SYNOPSIS

    use parent qw/Tako::Model/;

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
