#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::FreshMeat::API' );
}

diag( "Testing WWW::FreshMeat::API $WWW::FreshMeat::API::VERSION, Perl $], $^X" );
