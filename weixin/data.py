# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-19 10:03:01>
##-------------------------------------------------------------------
# import MySQLdb
from pymmseg import mmseg

mmseg.dict_load_defaults()
def word_split(sentence):
    text = '''放学前，老师把学生叫到办公室，拿出一片止痛片说：你把它吃下去吧。学生不解的问：我哪儿也不疼啊。老师回答：过会儿就疼了，我已经把你考试不及格的事告诉你爸爸了'''
    algor = mmseg.Algorithm(text)
    for tok in algor:
        print '%s [%d..%d]' % (tok.text, tok.start, tok.end)
    return None
## File : data.py