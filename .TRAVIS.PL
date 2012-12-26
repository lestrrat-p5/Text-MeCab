#!perl
use strict;
use Cwd ();

sub mysystem(@) {
    system(@_) == 0 or die "Failed to execute @_: $!";
}

sub mychdir::DESTROY {
    chdir $_[0]->{o_dir};
}
sub mychdir(@) {
    my $guard = bless { o_dir => Cwd::abs_path() }, "mychdir";
    chdir $_[0];
    return $guard;
}

sub cpanm (@) {
    @_ = ("cpanm", "-v", "--notest", @_);
    goto &mysystem;
}

sub main {
    # download latest mecab and mecab-ipadic
    my $mecab_version = "0.994";
    my $ipadic_version = "2.7.0-20070801";
    mysystem("curl", "-LO", "http://mecab.googlecode.com/files/mecab-$mecab_version.tar.gz");
    mysystem("curl", "-LO", "http://downloads.sourceforge.net/project/mecab/mecab-ipadic/$ipadic_version/mecab-ipadic-$ipadic_version.tar.gz");

    my $cwd = Cwd::abs_path();
    mysystem("tar", "-xvzf", "mecab-$mecab_version.tar.gz");
    {
        my $guard = mychdir("mecab-$mecab_version");
        mysystem("./configure", "--prefix=$cwd/mecab");
        mysystem("make", "install");
    }

    mysystem("tar", "-xvzf", "mecab-ipadic-$ipadic_version.tar.gz");
    {
        my $guard = mychdir("mecab-ipadic-$ipadic_version");
        mysystem("./configure", "--with-charset=utf8", "--with-mecab-config=$cwd/mecab/bin/mecab-config");
        mysystem("make", "install");
    }

    cpanm(qw(
        Module::Install
        Module::Install::AuthorTests
        Module::Install::CheckLib
        Module::Install::Repository
        Module::Install::XSUtil
    ));
    cpanm(qw(--installdeps .));

    mysystem("perl", "Makefile.PL", "--encoding=utf-8", "--mecab-config=$cwd/mecab/bin/mecab-config");
    mysystem("make", "test");
}

main unless caller();