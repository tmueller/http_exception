use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'HTTP::Exception',
    license             => 'perl',
    dist_author         => q{Thomas Mueller <thomas.mi.iller@gmail.com>},
    dist_version_from   => 'lib/HTTP/Exception.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'HTTP-Exception-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
