use Test::Exception;
use Test::More;
use HTTP::Exception;
use HTTP::Status;

################################################################################
eval { HTTP::Exception::200->throw };
my $e = HTTP::Exception->caught;
ok  defined $e                                   , 'HTTP::Exception caught' ;
is  $e->code, 200                                , 'HTTP::Exception has right code';
ok  defined HTTP::Exception::200->caught         , '200 caught' ;
ok  defined HTTP::Exception::OK->caught          , 'OK caught' ;
ok  !(defined HTTP::Exception::NOT_FOUND->caught), 'NOT_FOUND not caught' ;
ok  !(defined HTTP::Exception::404->caught)      , '404 not caught' ;
ok  defined Exception::Class->caught             , 'Exception::Class caught' ;

eval { HTTP::Exception::OK->throw };
my $e2 = HTTP::Exception->caught;
ok  defined $e2                                   , 'HTTP::Exception caught' ;
is  $e2->code, 200                                , 'HTTP::Exception has right code';
ok  defined HTTP::Exception::200->caught         , '200 caught' ;
ok  defined HTTP::Exception::OK->caught          , 'OK caught' ;
ok  !(defined HTTP::Exception::NOT_FOUND->caught), 'NOT_FOUND not caught' ;
ok  !(defined HTTP::Exception::404->caught)      , '404 not caught' ;
ok  defined Exception::Class->caught             , 'Exception::Class caught' ;

eval { HTTP::Exception->throw(200) };
my $e3 = HTTP::Exception->caught;
ok  defined $e3                                   , 'HTTP::Exception caught' ;
is  $e3->code, 200                                , 'HTTP::Exception has right code';
ok  defined HTTP::Exception::200->caught         , '200 caught' ;
ok  defined HTTP::Exception::OK->caught          , 'OK caught' ;
ok  !(defined HTTP::Exception::NOT_FOUND->caught), 'NOT_FOUND not caught' ;
ok  !(defined HTTP::Exception::404->caught)      , '404 not caught' ;
ok  defined Exception::Class->caught             , 'Exception::Class caught' ;


done_testing;