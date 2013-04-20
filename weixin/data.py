# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-20 10:50:02>
##-------------------------------------------------------------------
# import MySQLdb
from datetime import datetime
from pymmseg import mmseg

mmseg.dict_load_defaults()
mmseg.dict_load_words("woojuu.dic")
# python -c "import data; data.word_split('37,超大杯星巴克焦糖玛奇朵')"
def word_split(sentence, shall_print=True):
    algor = mmseg.Algorithm(sentence)
    token_list = []
    for tok in algor:
        token_list.append((tok.text, tok.start, tok.end))

    # temporarily print 
    if shall_print is True:
        for text, start, end in token_list:
            print "%s, %d, %d" % (text, start, end)
    return token_list

def split_expense_word(sentence):
    # print "split_expense_word(%s)" % sentence
    sentence = sentence.encode('utf-8', 'ignore')
    algor = mmseg.Algorithm(sentence)
    token_list = word_split(sentence, False)
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    category = detect_category(token_list)
    amount = detect_amount(token_list) # TODO: error handling
    branding = detect_branding(token_list)
    comment = sentence
    return (date, category, amount, branding, comment)

# TODO: rewrite in erlang or golang later
def detect_amount(token_list):
    amount = -1
    for text, start, end in token_list:
        if text.isdigit() is True:
            amount = int(text)
    return amount

# TODO: rewrite in erlang or golang later
def detect_branding(token_list):
    return "星巴克"

# TODO: rewrite in erlang or golang later
def detect_category(token_list):
    return "饮料"
## File : data.py