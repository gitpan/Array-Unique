use ExtUtils::MakeMaker;


WriteMakefile(
    'NAME'		=> 'Array::Unique',
    'VERSION_FROM'	=> 'Unique.pm',
    'PREREQ_PM'		=> {'Tie::IxHash' => '1.21', Test::More => '0.47'},
    ($] >= 5.006 ?    
      (ABSTRACT_FROM => 'Unique.pm', 
       AUTHOR     => 'Gabor Szabo <gabor@tracert.com>') : ()),
);
