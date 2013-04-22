# -*- CODING: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : data.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-22 22:04:38>
##-------------------------------------------------------------------
import MySQLdb
from datetime import datetime
from datetime import timedelta

import util
from util import log
import config
from expense import Expense

def split_expense_word(sentence):
    # print "split_expense_word(%s)" % sentence
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

def insert_expense(expense):
    conn = MySQLdb.connect(config.DB_HOST, config.DB_USERNAME, config.DB_PWD, \
                           config.DB_NAME, charset='utf8', port=config.DB_PORT)
    cursor = conn.cursor()

    sql = Expense.generate_insert_sql(expense)
    try:
        cursor.execute(sql)
        conn.commit()
    except:
        log.error("ERROR insert mysql fail")
        conn.rollback()

    cursor.close()
    # # TODO: defensive check
    return True

def user_summary(userid):
    # TODO support date is given as parameter
    end_date = datetime.now()
    # TODO: pre-caculate below data, if performance is slow
    conn = MySQLdb.connect(config.DB_HOST, config.DB_USERNAME, config.DB_PWD, \
                           config.DB_NAME, charset='utf8', port=config.DB_PORT)
    cursor = conn.cursor()

    day_expense = get_total_amount(cursor, userid, end_date, 0)
    week_expense = get_total_amount(cursor, userid, end_date, -7)
    month_expense = get_total_amount(cursor, userid, end_date, -30)

    cursor.close()
    return (day_expense, week_expense, month_expense)

def get_total_amount(db_cursor, userid, end_date, offset_days=0):
    sql = "select sum(amount) from expenses where userid=\"%s\" and date>='%s' and date<='%s'" \
                                     % (userid, (end_date + timedelta(days=offset_days)).strftime('%Y-%m-%d'), \
                                        end_date.strftime('%Y-%m-%d'))
    db_cursor.execute(sql)
    out = db_cursor.fetchall()
    return float(out[0][0])

## File : data.py