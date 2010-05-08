use strict;
use Test::More;
use threads;
use_ok "Text::MeCab";

my $x = Text::MeCab->new; 
my @threads;
for (1..5) {
    push @threads, threads->create(sub{
        note( "spawned thread : " . threads->tid() );
    });
}

foreach my $thr (@threads) {
    note( "joining thread : " . $thr->tid );
    $thr->join;
}

ok(1);
done_testing();