use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTTP::Exception',
    license             => 'perl',
    dist_author         => q{Thomas Mueller <tmueller@cpan.org>},
    dist_version_from   => 'lib/HTTP/Exception.pm',
    build_requires => {qw~
        Test::More              0.88
        Test::Exception         0.29
    ~},
    requires => {qw~
        Exception::Class        1.29
        HTTP::Status            5.817
        Scalar::Util            1.22

        base                    0
        strict                  0
        warnings                0
    ~},
    add_to_cleanup      => [ 'HTTP-Exception-*' ],
    create_makefile_pl  => 'traditional',
);

$builder->create_build_script();
