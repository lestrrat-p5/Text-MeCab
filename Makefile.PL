#!perl
# $Id$
#
# Copyright (c) 2006-2008 Daisuke Maki <daisuke@endeworks.jp>
# All rights reserved.

use strict;
use ExtUtils::MakeMaker;

my $RUNNING_IN_HELL = $^O eq 'MSWin32';

sub run_probes
{
    my $config = do 'tools/probe_mecab.pl';
    die if $@;

    for(my $i = 0; $i < @ARGV; $i++) {
        if ($ARGV[$i] =~ /^--debugging$/) {
            splice(@ARGV, $i, 1);
            $config->{debugging} = 1;
            $i--;
        }
    }

    $config->{cflags} ||= '';
    $config->{cflags} .= ' -I src';

    print
        "Detected the following mecab information:\n",
        "   version: $config->{version}\n",
        "   cflags: $config->{cflags}\n",
        "   libs: $config->{libs}\n",
        "   include: $config->{include}\n",
    ;
    return $config;
}

sub check_lib
{
    my $config = shift;

    if (! $RUNNING_IN_HELL) {
        local @INC = @INC;
        unshift @INC, 'inc';
        require Devel::CheckLib;
        Devel::CheckLib::check_lib_or_exit(
            lib  => 'mecab',
            LIBS => [ split(/\s+/, $config->{libs}) ],
        );
    }
}

sub extract_constants
{
    my $config = shift;
    my $mecab_h = File::Spec->catfile($config->{include}, 'mecab.h');

    print "reading $mecab_h to find all constants\n";
    open my $fh, "<", $mecab_h or die "Can't open $mecab_h";

    my %CONSTANTS;
    while (<$fh>) {
        if (/^#define\s+([\w_]+)\s+([\w_+])\s*$/) {
            $CONSTANTS{$1} = $2;
        }
    }

    open my $const_fh, '>', "const-xs.inc" or die "Can't open const-xs.inc for writing: $!";
    print $const_fh
        join("\n",
            "IV",
            "constant()",
            "    ALIAS:",
            (map { "        " . join(" = ", $_, $_) } keys %CONSTANTS),
            "    CODE:",
            "        RETVAL = ix;",
            "    OUTPUT:",
            "        RETVAL"
        )
    ;
    close($const_fh);
    close($fh);
}

sub define_symbols
{
    my $config = shift;
    my @define;

    if ($RUNNING_IN_HELL) { # save us, the Win32 puppies
        # XXX - Note to self: 
        #  (1) first there was the need to to protect the symbol value
        #      from being garbled by the shell
        #  (2) then the Redmond camp apparently decided that they don't like
        #      my quoting.
        #  (3) So charsbar provided this patch.
        @define = (
            qq(-DTEXT_MECAB_ENCODING=\\"$config->{encoding}\\"),
            qq(-DTEXT_MECAB_CONFIG=\\"$config->{config}\\"),
        );
    } else {
        @define = (
            "-DTEXT_MECAB_ENCODING='\"$config->{encoding}\"'",
            "-DTEXT_MECAB_CONFIG='\"$config->{config}\"'",
        );
    }

    if ($config->{debugging}) {
        push @define, "-DTEXT_MECAB_DEBUG=1";
    }
    $config->{define} = \@define;
}

sub prepare_makefile
{
    # Hack. I don't like the layout where .xs files are on the top level.
    link("lib/Text/MeCab.xs", "MeCab.xs");

    # if no inc directory is found, I'm being executed via the author.
    # I'm going to create inc, and add Devel::CheckLib there
    if (! -d './inc' and ! $RUNNING_IN_HELL) {
        mkdir('inc') or die "Could not make inc directory: $!";
        mkdir('inc/Devel') or die "Could not make inc/Devel directory: $!";
        require Devel::CheckLib;

        link($INC{'Devel/CheckLib.pm'}, 'inc/Devel/CheckLib.pm') or
            die "Failed to copy Devel::CheckLib: $!";
    }


    my $config = run_probes();
    check_lib($config);
    define_symbols($config);
    extract_constants($config);


    my %INFO = (
        ABSTRACT     => 'Alternative Interface To libmecab',
        AUTHOR       => 'Daisuke Maki <daisuke@endeworks.jp>',
        CCFLAGS      => $config->{cflags},
        DEFINE       => join( " ", @{ $config->{define} } ),
        DISTNAME     => 'Text-MeCab',
        INSTALLDIRS  => 'site',
        LIBS         => [ split(/\s+/, $config->{libs}) ],
        LICENSE      => 'perl',
        NAME         => 'Text::MeCab',
        OBJECT       => '$(O_FILES)',
        PREREQ_PM    => {
            'Class::Accessor::Fast' => 0,
            'Encode'                => 0,
            'Exporter'              => 0,
            'File::Spec'            => 0,
            'Test::More'            => 0,
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
    $INFO{OPTIMIZE} = '-g' if $config->{debugging};

    WriteMakefile(%INFO);
}

prepare_makefile();
