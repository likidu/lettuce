//
//  UIAlertView+Helper.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-29.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (Helper)

+ (void) showError:(NSString* )message, ...;
+ (void) showMessage: (NSString *) message, ...;
+ (void) showWaitNotification: (NSString *) message, ...;

@end
