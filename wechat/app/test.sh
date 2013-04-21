#!/bin/bash
##-------------------------------------------------------------------
## @copyright 2013 ShopEx Network Technology Co,.Ltd
## File : test.sh
## Author : filebat <markfilebat@126.com>
## Description :
## --
## Created : <2013-04-20>
## Updated: Time-stamp: <2013-04-20 11:17:38>
##-------------------------------------------------------------------

function request_url_get() {
    url=${1?}
    command="curl \"$url\""
    echo "$command"
    eval "$command"
    echo ""
}

request_url_get "http://0.0.0.0:8082/add_expense?userid=denny&expense=37,超大杯星巴克焦糖玛奇朵"

# request_url_get "http://0.0.0.0:8082/add_expense?userid=denny&expense=37,超大杯星巴克焦糖玛奇朵"

## File : test.sh ends
