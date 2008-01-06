#!perl
use strict;
use utf8;
use Test::More (tests => 28);
use Encode;

BEGIN
{
    use_ok("Text::MeCab");
}

my $data = {
    taro => encode(Text::MeCab::ENCODING, "太郎は次郎が持っている本を花子に渡した。"),
    sumomo => encode(Text::MeCab::ENCODING, "すもももももももものうち。"),
};

my $mecab = Text::MeCab->new;

my $node_A_orig = $mecab->parse($data->{taro});
ok($node_A_orig, "Original node A OK");
my $node_A = $node_A_orig->dclone;

my $node_B_orig = $mecab->parse($data->{sumomo});
ok($node_B_orig, "Original node B OK");
my $node_B = $node_B_orig->dclone;

# XXX - better be at least 5 nodes after parsing (this may actually depend
# on the dictionary that you are using, but heck, if you are crazy enough
# to muck with the dictionary, then you know how to diagnose this test)

for(1..5) {
    ok($node_A, "Deep clone node A OK");
    ok($node_B, "Deep clone node B OK");
    isa_ok($node_A, "Text::MeCab::Node::Cloned", "Deep clone node A isa OK");
    isa_ok($node_B, "Text::MeCab::Node::Cloned", "Deep clone node B isa OK");

    if ($node_A->length != 0 || $node_B->length != 0) {
        isnt($node_A->surface, $node_B->surface, 
            sprintf(
                "Contents of cloned nodes must differ (A = %s, B = %s)",
                $node_A->surface,
                $node_B->surface,
            )
        );
    }

    $node_A = $node_A->next;
    $node_B = $node_B->next;
}