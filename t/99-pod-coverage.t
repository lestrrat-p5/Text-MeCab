#!perl
use Test::More;
BEGIN {
    eval "use Test::Pod";
    eval "use Test::Pod::Coverage";
    if ($@) {
        plan(skip_all => "Test::Pod::Coverage required for testing POD");
        eval "sub pod_coverage_ok {}";
    } else {
        plan(tests    => 1);
    }
}

pod_coverage_ok('Text::MeCab', { trustme => [qr{^xs_}, qr{^MECAB_[A-Z_]+$}] });
