#!perl
use strict;
use warnings;
use utf8;
use blib;
use YAML;
use Path::Class::Dir;
use Path::Class::File;
use Text::MeCab::Dict;
use encoding 'utf-8';

my ($name, $yomi, $dict_source, $dic_dir, $user_dic_dir, $user_dic_file, $user_csv_file) = @ARGV;

my $dict = Text::MeCab::Dict->new(
    dict_source => $dict_source
);

my %args = (
    surface  => $name,
    original => $name,
    yomi     => $yomi,
    cost     => 3000,
    left_id  => 1291,
    right_id => 1291,
    pos       => '名詞',
    category1 => '固有名詞',
    category2 => '人名',
);
$dict->add(%args);

$dict->make_user_dic(
    dic_dir       => $dic_dir,
    user_dic_dir  => $user_dic_dir,
    user_dic_file => $user_dic_file,
    user_csv_file => $user_csv_file,
);
