#!perl
use strict;
use Test::More qw(no_plan);

BEGIN
{
    use_ok("Text::MeCab");
}

my $node;
my $data = do 't/strings.dat'; die if $@;
{
    my $mecab = Text::MeCab->new;
    $node = $mecab->parse($data->{taro});
    $mecab = undef;
}

ok($node); # yes, node exists, but DO NOT use node->surface.
