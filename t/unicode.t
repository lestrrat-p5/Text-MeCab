use strict;
use warnings;
use Test::More tests => 4;

binmode Test::More->builder->$_ => ':utf8'
    for qw(output failure_output todo_output);

use Text::MeCab;

my $unicode = "\x{308F}\x{305F}\x{3057}"; # single word

my $mecab = eval {
    Text::MeCab->new({
        unicode => 1, # support unicde
    });
};
isa_ok($mecab, 'Text::MeCab', "new() accepts param 'unicode'");

my $node = eval { $mecab->parse($unicode) };
isa_ok($node, 'Text::MeCab::Node', 'parse() takes unicode');

if ($node) {
    is  ($node->surface, $unicode,     'surface() returns unicode');
    like($node->feature, qr/$unicode/, 'feature() returns unicode');
}
