#!perl
# $Id$
#
# Copyright (c) 2006-2008 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use strict;
use ExtUtils::MakeMaker;

my $debugging = 0;
for(my $i = 0; $i < @ARGV; $i++) {
    if ($ARGV[$i] =~ /^--debugging$/) {
        splice(@ARGV, $i, 1);
        $debugging = 1;
        $i--;
    }
}


my $result = do 'tools/probe_mecab.pl';
die if $@;

print
    "Detected the following mecab information:\n",
    "   version: $result->{version}\n",
    "   cflags: $result->{cflags}\n",
    "   libs: $result->{libs}\n"
;

# XXX - I want to include this in future releases, but I don't know if
# it works with Win32 properly (i.e., untested)
# use Devel::CheckLib;
# check_lib_or_exit(
#     lib  => 'mecab',
#     LIBS => join(' ', split(/\s+/, $result->{libs})),
# );

$result->{cflags} ||= '';
$result->{cflags} .= ' -I src';

# Hack. I don't like the layout where .xs files are on the top level.
link("lib/Text/MeCab.xs", "MeCab.xs");

my @define = (
    "-DTEXT_MECAB_ENCODING='\"$result->{encoding}\"'",
    "-DTEXT_MECAB_CONFIG='\"$result->{config}\"'",
);
if ($debugging) {
    push @define, "-DTEXT_MECAB_DEBUG=1";
}

my %INFO = (
    ABSTRACT     => 'Alternative Interface To libmecab',
    AUTHOR       => 'Daisuke Maki <daisuke@endeworks.jp>',
    CCFLAGS      => $result->{cflags},
    DEFINE       => join( " ", @define ),
    DISTNAME     => 'Text-MeCab',
    INSTALLDIRS  => 'site',
    LIBS         => [ split(/\s+/, $result->{libs}) ],
    NAME         => 'Text::MeCab',
    OBJECT       => '$(O_FILES)',
    PREREQ_PM    => {
#        'Devel::CheckLib' => 0,
        'Class::Accessor::Fast' => 0,
        'Encode'                => 0,
        'Exporter'              => 0,
        'File::Spec'            => 0,
        'Test::More'            => 0,
        'Text::CSV_XS'          => 0,
        'Path::Class'           => 0,
    },
    VERSION_FROM => 'lib/Text/MeCab.pm',
    clean        => {
        FILES => 'lib/typemap MeCab.xs'
    },
    test         => {
        TESTS    => 't/*.t t/*/*.t'
    }
);
$INFO{OPTIMIZE} = '-g' if $debugging;

WriteMakefile(%INFO);
