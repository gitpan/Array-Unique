use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'Array::Unique',
	license             => 'perl',
	dist_author         => 'Gabor Szabo <gabor@pti.co.il>',
	dist_abstract       => 'Tie-able array that allows only unique values',
	create_makefile_pl  => 'traditional',
	create_readme       => 1,
	requires            => {
		'Test::More'       => 0.47,
		'perl'             => '0.006',
	},
);

$builder->create_build_script();

