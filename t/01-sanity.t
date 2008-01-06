#!perl
use strict;
use Test::More qw(no_plan);;

BEGIN
{
    use_ok("Text::MeCab", ':all');
}

if (&Text::MeCab::MECAB_VERSION >= 0.90) {
    ok(eval { my $v = MECAB_NOR_NODE; 1 } && !$@, "MECAB_NOR_NODE ok");
    ok(eval { my $v = MECAB_UNK_NODE; 1 } && !$@, "MECAB_UNK_NODE ok");
    ok(eval { my $v = MECAB_BOS_NODE; 1 } && !$@, "MECAB_BOS_NODE ok");
    ok(eval { my $v = MECAB_EOS_NODE; 1 } && !$@, "MECAB_EOS_NODE ok");
}

# Make sure that what Text::MeCab::Node can, Text::MeCab::Node::Cloned
# also can do.
my @methods = (
    qw(id surface feature length prev next stat cost),
    qw(rlength rcattr lcattr posid char_type isbest alpha beta prob wcost)
);
foreach my $method (@methods) {
    # test one by one to make it easier to read
    can_ok("Text::MeCab::Node", $method);
    can_ok("Text::MeCab::Node::Cloned", $method);
}

1;