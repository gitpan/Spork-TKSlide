
use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Kang-min Liu (gugod@gugod.org)',
    ABSTRACT            => 'Spork backend for TKSlide (fancy look html slideshow)',
    NAME                => 'Spork::TKSlide',
    VERSION		=> '0.04_1',
    DISTNAME            => 'Spork-TKSlide',
    PREREQ_PM           => {
        'Spork'   => '0.16',
    },
    dist                => {
        COMPRESS        => 'gzip -9',
        SUFFIX          => '.gz',
    },
);

