package Tako::Web::Dispatcher;
use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterSimple;

use Tako::Web::C::Root;
use Tako::Web::C::User;
use Tako::Web::C::Setting;

connect '/'           => 'Root#index';
connect '/user/'      => 'User#index';
connect '/setting/'   => 'Setting#index';

1;
