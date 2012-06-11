//
//  CookieUtility.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookieUtility : NSObject

+ (void)setCookie: (NSArray*)cookie;

+ (void)removeCookie: (NSHTTPCookie*)cookie;

@end
