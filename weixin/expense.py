# -*- CODING: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : expense.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-01-25 00:00:00>
## Updated: Time-stamp: <2013-04-22 20:58:08>
##-------------------------------------------------------------------
class Expense:
    def __init__(self):
        self.userid = ""
        self.source_expenseid = ""
        self.amount = -1
        self.branding = ""
        self.category = ""
        self.date = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.notes = ""

    def init_with_sqlite(self, userid, expenseid, amount, categoryid, date, notes, latitude, longitude, branding=""):
        self.userid = userid
        self.source_expenseid = expenseid.strip()
        self.amount = amount
        self.category = categoryid # TODO make conversion
        self.date = date.strip() # TODO defensive code
        self.latitude = latitude
        self.longitude = longitude
        self.notes = my_strip(notes)

    def init_with_ledger(self, userid, amount, category, date, notes):
        self.userid = userid
        self.amount = amount
        self.category = category # TODO make conversion
        self.date = date.strip() # TODO defensive code
        self.notes = my_strip(notes)

    @staticmethod
    def print_obj(obj):
        print "userid:%s, amount:%f, category:%s, date:%s, latitude:%f, longitude:%f, notes:%s\n" % \
            (obj.userid, obj.amount, obj.category, \
             obj.date, obj.latitude, obj.longitude, obj.notes)

    @staticmethod
    def print_objs(objs):
        for obj in objs:
            obj.print_obj(obj)
############################### HELPER FUNCTIONS #############################
def my_strip(string):
    string = string.strip()
    string = string.replace("\n", "")
    return string
##############################################################################

## File : expense.py