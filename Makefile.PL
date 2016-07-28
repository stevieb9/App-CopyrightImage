use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'App::CopyrightImage',
    AUTHOR           => q{Steve Bertrand <steveb@cpan.org>},
    VERSION_FROM     => 'lib/App/CopyrightImage.pm',
    ABSTRACT_FROM    => 'lib/App/CopyrightImage.pm',
    LICENSE          => 'Perl_5',
    PL_FILES         => {},
    EXE_FILES        => [
        'bin/imgcopyright'
    ],
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'File::Find::Rule'  => 0,
        'Image::ExifTool'   => 10.20,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'App-CopyrightImage-*' },
);
