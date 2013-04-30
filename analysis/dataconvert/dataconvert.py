#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : dataconvert.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-03-30>
## Updated: Time-stamp: <2013-04-30 11:45:46>
##-------------------------------------------------------------------
import MySQLdb
import sys
import commands

from expense import Expense
################################## CONSTANT ###################################
DB_HOST = "127.0.0.1"
DB_USERNAME = "user_2013"
DB_PWD = "ilovechina"
DB_NAME = "wj"

LEDGER_BLANK_LINE = 0
LEDGER_NOTE_LINE = 1
LEDGER_TO_ACCOUNT_LINE = 2
LEDGER_FROM_ACCOUNT_LINE = 3

SQLITE_ENTRY_SEPERATOR = "--line ends--"
##############################################################################

# dataconvert.load_ledger("./data/test.ledger", "denny")
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
            expense.init_with_ledger(userid, float(amount), \
                                     category, date, notes)
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

# dataconvert.load_sqlite("./data/test.sqlite", "liki")
def load_sqlite(sqlite_file, userid):
    expenses = []
    sql = "select expenseid, amount, categoryname as categoryid, date, notes, latitude, longitude, \"%s\"" + \
          " from expense inner join category on expense.categoryid = category.categoryid" 
    sql = sql % SQLITE_ENTRY_SEPERATOR
    command = "sqlite3 %s '%s'" \
              % (sqlite_file, sql)
    status, output = commands.getstatusoutput(command)
    if status != 0:
        print "Error: Failed to run the command:%s. output:%s" % (command_str, output)
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
        if notes.find("[tag:private]") == -1:
            expenses.append(expense)
        #expense.print_obj()

    return expenses

def insert_mysql(expenses):
    # Expense.print_objs(expenses)
    conn = MySQLdb.connect(DB_HOST, DB_USERNAME, DB_PWD, DB_NAME, charset = 'utf8', port = 3306)
    c = conn.cursor()

    for obj in expenses:
        sql = "insert into expenses(userid, source_expenseid, amount, category, date, latitude, longitude, notes) " + \
              "values (\"%s\", \"%s\", %f, \"%s\", \"%s\", %f, %f, \"%s\");" % \
              (obj.userid, obj.source_expenseid, obj.amount, obj.category, \
               obj.date, obj.latitude, obj.longitude, obj.notes)
        print sql
        try:
            c.execute(sql)
            conn.commit()
        except:
            print "ERROR insert mysql fail"
            conn.rollback()

    # # TODO close db connection
    # # TODO: defensive check
    return True

# python -c "import dataconvert; dataconvert.ledger_to_url_request('../data/test.ledger', 'dennyledger')"
def ledger_to_url_request(fname, userid):
    expenses = load_ledger(fname, userid)
    for expense in expenses:
        print "request_url_post 'http://0.0.0.0:5000/add_expense' 'userid=%s&notes=%s'" \
            % (userid, expense.notes)

# python -c "import dataconvert; dataconvert.sqlite_to_url_request('../data/test.sqlite', 'likisqlite')"
def sqlite_to_url_request(fname, userid):
    expenses = load_sqlite(fname, userid)
    for expense in expenses:
        print "request_url_post 'http://0.0.0.0:5000/add_expense' 'userid=%s&notes=%s'" \
            % (userid, expense.notes)

# ./dataconvert.py import denny ../data/test.ledger
# ./dataconvert.py import liki ../data/test.sqlite
if __name__ == "__main__":
    if sys.argv[1] == "import":
        userid = sys.argv[2]
        fname = sys.argv[3]
        if fname.endswith(".ledger") is True:
            expenses = load_ledger(fname, userid)
            insert_mysql(expenses)
        if fname.endswith(".sqlite") is True:
            expenses = load_sqlite(fname, userid)
            insert_mysql(expenses)
    else:
        print "Error unknown command:" + str(sys.argv)

## File : dataconvert.py ends
