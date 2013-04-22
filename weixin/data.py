# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-22 17:10:49>
##-------------------------------------------------------------------
import MySQLdb
from datetime import datetime
import util
import config

def split_expense_word(sentence):
    # print "split_expense_word(%s)" % sentence
    sentence = sentence.encode('utf-8', 'ignore')
    token_list = util.word_split(sentence, True)
    date = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    (branding, category) = detect_branding_category(token_list)
    amount = detect_amount(token_list)
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
def detect_branding_category(token_list):
    for text, start, end in token_list:
        if util.branding_category_dict.has_key(text):
            return (text, util.branding_category_dict[text])
    return ("", "")

def insert_expense(userid, source_expenseid, amount, category, date, notes, latitude=-1, longitude=-1):
    conn = MySQLdb.connect(config.DB_HOST, config.DB_USERNAME, config.DB_PWD, \
                           config.DB_NAME, charset='utf8', port=3306)
    cursor = conn.cursor()

    sql = "insert into expenses(userid, source_expenseid, amount, category, date, latitude, longitude, notes) " + \
          "values (\"%s\", \"%s\", %f, \"%s\", \"%s\", %f, %f, \"%s\");" % \
          (userid, source_expenseid, amount, category, date, latitude, longitude, notes)

    try:
        cursor.execute(sql)
        conn.commit()
    except:
        print "ERROR insert mysql fail"
        conn.rollback()

    cursor.close()
    # # TODO: defensive check
    return True

## File : data.py