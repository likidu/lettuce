# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-20 00:47:28>
##-------------------------------------------------------------------
# import MySQLdb
from pymmseg import mmseg

mmseg.dict_load_defaults()
mmseg.dict_load_words("woojuu.dic")
# python -c "import data; data.word_split('37,超大杯星巴克焦糖玛奇朵')"
def word_split(sentence):
    algor = mmseg.Algorithm(sentence)
    for tok in algor:
        print '%s [%d..%d]' % (tok.text, tok.start, tok.end)
    return None
## File : data.py