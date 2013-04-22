# -*- coding: utf-8 -*-
#!/usr/bin/python
##-------------------------------------------------------------------
## @copyright 2013
## File : util.py
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-11 00:00:00>
## Updated: Time-stamp: <2013-04-22 17:58:39>
##-------------------------------------------------------------------
from pymmseg import mmseg

mmseg.dict_load_defaults()
mmseg.dict_load_words("woojuu.dic")

import logging
format = "%(asctime)s %(filename)s:%(lineno)d - %(levelname)s: %(message)s"
formatter = logging.Formatter(format)

consoleHandler = logging.StreamHandler()
consoleHandler.setLevel(logging.INFO)
consoleHandler.setFormatter(formatter)

filehandler = logging.FileHandler("wooju_uweixin.log")
filehandler.setLevel(logging.INFO)
filehandler.setFormatter(formatter)

log = logging.getLogger("wooju_uweixin_gateway")
log.setLevel(logging.INFO)
log.addHandler(consoleHandler)
log.addHandler(filehandler)

# TODO: the dictionary shall be retrieved from db
branding_category_dict = {
    "星巴克":"饮料"
}
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

## File : util.py