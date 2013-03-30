#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : dataconvert.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-03-30>
## Updated: Time-stamp: <2013-03-30 14:45:47>
##-------------------------------------------------------------------
# import MySQLdb
# import MySQLdb
import sys
import logging
import commands

################################## CONSTANT #####################################
DB_HOST="127.0.0.1"
DB_USERNAME="user_2013"
DB_PWD="ilovechina"
DB_NAME="wj"

LEDGER_BLANK_LINE = 0
LEDGER_NOTE_LINE = 1
LEDGER_TO_ACCOUNT_LINE =2
LEDGER_FROM_ACCOUNT_LINE =3

SQLITE_ENTRY_SEPERATOR = "--line ends--"
##############################################################################

########################### GLOBAL VARIABLES #################################
format = "%(asctime)s %(filename)s:%(lineno)d - %(levelname)s: %(message)s"
formatter = logging.Formatter(format)

consoleHandler = logging.StreamHandler()
consoleHandler.setLevel(logging.INFO)
consoleHandler.setFormatter(formatter)
##############################################################################

class Expense:
    def __init__(self):
        self.userid = ""
        self.source_expenseid = ""
        self.amount = -1
        self.category = ""
        self.date = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.notes = ""

    def init_with_sqlite(self, userid, expenseid, amount, categoryid, date, notes, latitude, longitude):
        self.userid = userid
        self.source_expenseid = expenseid.strip()
        self.amount = amount
        self.category = categoryid # TODO make conversion
        self.date = date.strip() # TODO defensive code
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes.strip()

    def init_with_ledger(self, userid, amount, category, date, notes):
        self.userid = userid
        self.amount = amount
        self.category = category # TODO make conversion
        self.date = date.strip() # TODO defensive code
        self.notes = notes.strip()

    def print_obj(self):
        print "userid:%s, source_expenseid:%s, amount:%f, category:%s, date:%s, latitude:%f, longitude:%f, notes:%s\n" % \
            (self.userid, self.source_expenseid, self.amount, self.category, \
             self.date, self.latitude, self.longitude, self.notes)

# dataconvert.load_ledger("/Users/mac/backup/essential/Dropbox/private_data/code/lettuce/analysis/data/test.ledger", "denny")
def load_ledger(ledger_file, userid):
    expenses = []
    f = open(ledger_file)
    lines = f.readlines()
    f.close()
    for line in lines[1:]:
        line_type = detect_ledger_line(line)
        if line_type == LEDGER_NOTE_LINE:
            expense = Expense()
            l = line.split("*")
            date = l[0]
            notes = l[1]
        if line_type == LEDGER_TO_ACCOUNT_LINE:
            l = line.lstrip().split(" ")
            category = l[0]
            amount = l[-1]
        if line_type == LEDGER_FROM_ACCOUNT_LINE:
            expense.init_with_ledger(userid, float(amount), category, date, notes)
            expenses.append(expense)
            #expense.print_obj()
    return expenses

def detect_ledger_line(line):
    if len(line) == 0 or line == "\n":
        return LEDGER_BLANK_LINE
    if line[0] != ' ':
        return LEDGER_NOTE_LINE
    line = line.lstrip()
    if line.find(' ') != -1:
        return LEDGER_TO_ACCOUNT_LINE
    else:
        return LEDGER_FROM_ACCOUNT_LINE

# dataconvert.load_sqlite("/Users/mac/backup/essential/Dropbox/private_data/code/lettuce/analysis/data/test.sqlite", "denny")
def load_sqlite(sqlite_file, userid):
    expenses = []
    command = "sqlite3 %s 'select expenseid, amount, categoryid, date, notes, latitude, longitude, \"%s\" from expense'" \
              % (sqlite_file, SQLITE_ENTRY_SEPERATOR)
    status, output = commands.getstatusoutput(command)
    if status != 0:
        log.error("Failed to run the command:%s. output:%s" % (command_str, output))
        return []

    l = output.split(SQLITE_ENTRY_SEPERATOR)
    for entry in l:
        field_list = entry.split("|")
        if len(field_list) <= 1:
            break
        expense = Expense()
        expenseid = field_list[0]
        amount = field_list[1]
        categoryid = field_list[2]
        date = field_list[3]
        notes = field_list[4]
        latitude = field_list[5]
        longitude = field_list[6]
        expense.init_with_sqlite(userid, expenseid, float(amount), categoryid, \
                                 date, notes, float(latitude), float(longitude))
        expenses.append(expense)
        #expense.print_obj()

    return expenses

# def insert_mysql(entries):
#     conn = MySQLdb.connect(config.DB_HOST, config.DB_USERNAME, config.DB_PWD, config.DB_NAME, charset='utf8', port=3306)
#     c=conn.cursor()
#     sql = "insert into expenses(userid, source_expeseid, amount, category, date, latitude, longitude, nodes) " + \
#           "values (%s, %s, %s %s, %s, %s, %s, %s)" % \
#           (self.userid, self.source_expenseid, self.amount, self.category, \
#            self.date, self.latitude, self.longitude, self.notes)
#     c.execute("select id, category, title from posts where id ='%s'" % id)
#     out = c.fetchall()
#     # TODO close db connection
#     # TODO: defensive check
#     return True

## File : dataconvert.py ends
