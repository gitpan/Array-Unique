use ExtUtils::MakeMaker;


WriteMakefile(
    'NAME'		=> 'Array::Unique',
    'VERSION_FROM'	=> 'Unique.pm', # finds $VERSION
    'PREREQ_PM'		=> {'Tie::IxHash' => '1.21'},
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Unique.pm', # retrieve abstract from module
       AUTHOR     => 'Gabor Szabo <gabor@tracert.com>') : ()),
);
