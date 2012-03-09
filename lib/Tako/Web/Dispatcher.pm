package Tako::Web::Dispatcher;
use strict;
use warnings;
use utf8;

use Amon2::Web::Dispatcher::RouterSimple;

connect '/'           => 'Root#index';
connect '/user/'      => 'User#index';
connect '/setting/'   => 'Setting#index';

1;
