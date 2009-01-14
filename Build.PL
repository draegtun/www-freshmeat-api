use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::FreshMeat::API',
    license             => 'perl',
    dist_author         => 'draegtun (Barry Walsh) <draegtun@cpan.org>',
    dist_version_from   => 'lib/WWW/FreshMeat/API.pm',
    build_requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'WWW-FreshMeat-API-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
