use strict;
use Test::More;
use lib 't/lib';
use Test::HTTP::Exception::Ranges;

use HTTP::Exception qw(CLIENT_ERROR);

Test::HTTP::Exception::Ranges::simple_test_range_ok(qw~4XX~);

done_testing;