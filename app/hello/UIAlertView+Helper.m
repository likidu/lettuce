//
//  UIAlertView+Helper.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-29.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "UIAlertView+Helper.h"

@implementation UIAlertView (Helper)

+ (void) showError:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    
    NSString* formattedMessage;
    message = formattedMessage = [[NSString alloc] initWithFormat:message arguments:args];

    va_end(args);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错啦" 
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"好" 
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];    
    [formattedMessage release];
}

@end
