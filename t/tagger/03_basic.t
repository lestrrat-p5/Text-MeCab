#!perl
use strict;
use Test::More qw(no_plan);

BEGIN
{
    use_ok("Text::MeCab");
}

my $data = do 't/strings.dat'; die if $@;

my $mecab = Text::MeCab->new({
    all_morphs => 1
});
ok($mecab);

my @fields = qw(surface feature length cost);
if (&Text::MeCab::MECAB_VERSION >= 0.90) {
    push @fields, qw(rcattr lcattr stat isbest alpha beta prob wcost);
}

for (
    my $node = $mecab->parse($data->{taro});
    $node;
    $node = $node->next
) {
    foreach my $field (@fields) {
        my $p = eval { $node->$field };
        ok(!$@, "$field ok ($p)");
    }
}

$mecab = Text::MeCab->new({
    all_morphs => 1
});
ok($mecab);

for (
    my $node = $mecab->parse($data->{taro});
    $node;
    $node = $node->next
) {
    foreach my $field (@fields) {
        my $p = eval { $node->$field };
        ok(!$@, "$field ok ($p)");
    }
}


1;