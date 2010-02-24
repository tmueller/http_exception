#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'HTTP::Exception' ) || print "Bail out!
";
}

diag( "Testing HTTP::Exception $HTTP::Exception::VERSION, Perl $], $^X" );
