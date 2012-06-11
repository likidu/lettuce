//
//  CookieUtility.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "CookieUtility.h"
#import "Foundation/NSHttpCookieStorage.h"

@implementation CookieUtility

+ (void)setCookie: (NSHTTPCookie*)cookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)removeCookie: (NSHTTPCookie*)cookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
}

@end
