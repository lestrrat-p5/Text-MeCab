/* $Id: /mirror/Text-MeCab/lib/Text/MeCab.xs 6618 2007-04-16T06:12:59.796844Z daisuke  $
 *
 * Copyright (c) 2006-2008 Daisuke Maki <daisuke@endeworks.jp>
 * All rights reserved.
 */

#include "text-mecab.h"

MODULE = Text::MeCab    PACKAGE = Text::MeCab    PREFIX = TextMeCab_

PROTOTYPES: DISABLE

BOOT:
    TextMeCab_bootstrap();

TextMeCab *
TextMeCab__XS_new(class, args = NULL)
        char *class;
        AV   *args;
    CODE:
        RETVAL = TextMeCab_new_from_av(class, args);
    OUTPUT:
        RETVAL

TextMeCab_Node *
TextMeCab_parse(mecab, string)
        TextMeCab *mecab;
        char *string;

void
TextMeCab_DESTROY(mecab)
        TextMeCab *mecab;

MODULE = Text::MeCab    PACKAGE = Text::MeCab::Node    PREFIX = TextMeCab_Node_

PROTOTYPES: DISABLE

unsigned int
TextMeCab_Node_id(node)
    TextMeCab_Node *node

unsigned int
TextMeCab_Node_length(node)
    TextMeCab_Node *node

unsigned int
TextMeCab_Node_rlength(node)
    TextMeCab_Node *node

TextMeCab_Node *
TextMeCab_Node_next(node)
    TextMeCab_Node *node

TextMeCab_Node *
TextMeCab_Node_prev(node)
    TextMeCab_Node *node

SV *
TextMeCab_Node_surface(node)
    TextMeCab_Node *node;

const char *
TextMeCab_Node_feature(node)
    TextMeCab_Node *node;

unsigned short
TextMeCab_Node_rcattr(node)
    TextMeCab_Node *node;

unsigned short
TextMeCab_Node_lcattr(node)
    TextMeCab_Node *node;

unsigned short
TextMeCab_Node_posid(node)
    TextMeCab_Node *node;

unsigned char
TextMeCab_Node_char_type(node)
    TextMeCab_Node *node;

unsigned char
TextMeCab_Node_stat(node)
    TextMeCab_Node *node;

unsigned char
TextMeCab_Node_isbest(node)
    TextMeCab_Node *node;

float
TextMeCab_Node_alpha(node)
    TextMeCab_Node *node;

float
TextMeCab_Node_beta(node)
    TextMeCab_Node *node;

float
TextMeCab_Node_prob(node)
    TextMeCab_Node *node;

short
TextMeCab_Node_wcost(node)
    TextMeCab_Node *node;

long
TextMeCab_Node_cost(node)
    TextMeCab_Node *node;

const char *
TextMeCab_Node_format(node, mecab)
        TextMeCab_Node *node;
        TextMeCab      *mecab;

TextMeCab_Node_Cloned*
TextMeCab_Node_dclone(node)
    TextMeCab_Node *node;

MODULE = Text::MeCab    PACKAGE = Text::MeCab::Node::Cloned    PREFIX = TextMeCab_Node_Cloned_

PROTOTYPES: DISABLE

unsigned int
TextMeCab_Node_Cloned_id(node)
        TextMeCab_Node_Cloned *node

unsigned int
TextMeCab_Node_Cloned_length(node)
        TextMeCab_Node_Cloned *node

unsigned int
TextMeCab_Node_Cloned_rlength(node)
        TextMeCab_Node_Cloned *node

TextMeCab_Node_Cloned *
TextMeCab_Node_Cloned_next(node)
        TextMeCab_Node_Cloned *node

TextMeCab_Node_Cloned *
TextMeCab_Node_Cloned_prev(node)
        TextMeCab_Node_Cloned *node

const char *
TextMeCab_Node_Cloned_surface(node)
        TextMeCab_Node_Cloned *node;

const char *
TextMeCab_Node_Cloned_feature(node)
        TextMeCab_Node_Cloned *node;

unsigned short
TextMeCab_Node_Cloned_rcattr(node)
        TextMeCab_Node_Cloned *node;

unsigned short
TextMeCab_Node_Cloned_lcattr(node)
        TextMeCab_Node_Cloned *node;

unsigned short
TextMeCab_Node_Cloned_posid(node)
        TextMeCab_Node_Cloned *node;

unsigned char
TextMeCab_Node_Cloned_char_type(node)
        TextMeCab_Node_Cloned *node;

unsigned char
TextMeCab_Node_Cloned_stat(node)
        TextMeCab_Node_Cloned *node;

unsigned char
TextMeCab_Node_Cloned_isbest(node)
        TextMeCab_Node_Cloned *node;

float
TextMeCab_Node_Cloned_alpha(node)
        TextMeCab_Node_Cloned *node;

float
TextMeCab_Node_Cloned_beta(node)
        TextMeCab_Node_Cloned *node;

float
TextMeCab_Node_Cloned_prob(node)
        TextMeCab_Node_Cloned *node;

short
TextMeCab_Node_Cloned_wcost(node)
        TextMeCab_Node_Cloned *node;

long
TextMeCab_Node_Cloned_cost(node)
        TextMeCab_Node_Cloned *node;

const char *
TextMeCab_Node_Cloned_format(node, mecab)
        TextMeCab_Node_Cloned *node;
        TextMeCab             *mecab;

void 
TextMeCab_Node_Cloned_DESTROY(node)
        TextMeCab_Node_Cloned *node;
    CODE:
        TextMeCab_Node_Cloned_free(node);
