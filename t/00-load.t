use strict;

use Test::More;

BEGIN {
    use_ok 'HTTP::Exception::1XX';
    use_ok 'HTTP::Exception::2XX';
    use_ok 'HTTP::Exception::3XX';
    use_ok 'HTTP::Exception::4XX';
    use_ok 'HTTP::Exception::5XX';
    use_ok 'HTTP::Exception::Base';
    use_ok 'HTTP::Exception::Loader';
    use_ok 'HTTP::Exception';
}

done_testing;