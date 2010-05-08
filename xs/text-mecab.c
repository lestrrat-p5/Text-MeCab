/* $Id$
 *
 * Copyright (c) 2006-2008 Daisuke Maki <disuke@endeworks.jp>
 * All rights reserved.
 */

#include "text-mecab.h"
#ifndef  __TEXT_MECAB_C__
#define  __TEXT_MECAB_C__

void
TextMeCab_bootstrap()
{
    HV *stash;
    stash = gv_stashpv("Text::MeCab", 1);

    newCONSTSUB(stash, "MECAB_VERSION", newSVpvf("%s", mecab_version()));
    newCONSTSUB(stash, "MECAB_TARGET_VERSION", 
        newSVpvf("%d.%02d", MECAB_MAJOR_VERSION, MECAB_MINOR_VERSION) );
    newCONSTSUB(stash, "MECAB_TARGET_MAJOR_VERSION", 
        newSVpvf("%d", MECAB_MAJOR_VERSION));
    newCONSTSUB(stash, "MECAB_TARGET_MINOR_VERSION", 
        newSVpvf("%d", MECAB_MINOR_VERSION));
    newCONSTSUB(stash, "ENCODING", newSVpvf("%s", TEXT_MECAB_ENCODING) );

    newCONSTSUB(stash, "MECAB_CONFIG", newSVpvf("%s", TEXT_MECAB_CONFIG));
}

TextMeCab *
TextMeCab_new(class, argv, argc)
        char *class;
        char **argv;
        unsigned int argc; 
{
    SV *sv;
    TextMeCab *mecab;
#if TEXT_MECAB_DEBUG
    {
        int i;

        PerlIO_printf(PerlIO_stderr(), "TextMeCab_new called\n");
        for(i = 0; i < argc; i++) {
            PerlIO_printf(PerlIO_stderr(), "  arg %d: %s\n", i, argv[i]);
        }
    }
#endif
    mecab = mecab_new(argc, argv);
    return mecab;
}

TextMeCab *
TextMeCab_new_from_av(class, av)
        char *class;
        AV   *av;
{
    char **argv;
    unsigned int argc;
    TextMeCab *mecab;

    argc = av_len(av) + 1;

    if (argc > 0) {
        int i;
        SV **svr;

        Newz(1234, argv, argc, char *);
        for(i = 0; i < argc; i++) {
            svr = av_fetch(av, i, 0);
            if (svr == NULL || ! SvOK(*svr)) {
                Safefree(argv);
                croak("bad argument at index %d", i);
            }

            argv[i] = SvPV_nolen(*svr);
        }
    }
    mecab = TextMeCab_new(class, argv, argc);
    if( mecab == NULL ) {
        if (argc > 0) {
            Safefree(argv);
        }
        croak("Failed to create mecab instance");
    }

    if (argc > 0) {
        Safefree(argv);
    }

    return mecab;
}

TextMeCab_Node *
TextMeCab_parse(mecab, string)
        TextMeCab *mecab;
        char *string;
{
    TextMeCab_Node *node;

    node = (TextMeCab_Node *) mecab_sparse_tonode(XS_2MECAB(mecab), string);
    if (node == NULL) {
        croak("mecab_sparse_tonode() failed: %s", 
            mecab_strerror(XS_2MECAB(mecab)));
    }
    node = node->next;

    return node;
}

void
TextMeCab_DESTROY(mecab)
        TextMeCab *mecab;
{
    mecab_destroy(mecab);
}

#endif /* __TEXT_MECAB_C__ */