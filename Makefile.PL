
use ExtUtils::MakeMaker;

WriteMakefile(
    AUTHOR              => 'Kang-min Liu (gugod@gugod.org)',
    ABSTRACT            => 'Spork backend for TKSlide',
    NAME                => 'Spork::Config::TKSlide',
    VERSION		=> '0.02',
    DISTNAME            => 'Spork-TKSlide',
    PREREQ_PM           => {
        'Spork'   => '0',
    },
    dist                => {
        COMPRESS        => 'gzip -9',
        SUFFIX          => '.gz',
    },
);

