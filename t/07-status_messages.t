use strict;

use Test::More;
use HTTP::Exception;

my $e = HTTP::Exception->new(404, status_message => 'Nothing here');
is  $e->status_message, 'Nothing here', 'status message with H::E + new ';

my $e2 = HTTP::Exception::404->new(status_message => 'Nothing here');
is  $e2->status_message, 'Nothing here', 'status message with H::E::404 + new';

my $e3 = HTTP::Exception::NOT_FOUND->new(status_message => 'Nothing here');
is  $e3->status_message, 'Nothing here', 'status message with H::E::NOT_FOUND + new';

my @tests = (
    sub { HTTP::Exception->throw(404, status_message => 'Nothing here');       },
    sub { HTTP::Exception::404->throw(status_message => 'Nothing here');       },
    sub { HTTP::Exception::NOT_FOUND->throw(status_message => 'Nothing here'); },
);

for my $test (@tests) {
    eval { $test->() };
    my $e4 = HTTP::Exception->caught;
    my $e5 = HTTP::Exception::404->caught;
    my $e6 = HTTP::Exception::NOT_FOUND->caught;
    is  $e4->status_message, 'Nothing here', 'status message with H::E';
    is  $e5->status_message, 'Nothing here', 'status message with H::E::404';
    is  $e6->status_message, 'Nothing here', 'status message with H::E::NOT_FOUND';
}



done_testing;