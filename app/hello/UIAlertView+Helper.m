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
    message = formattedMessage = [NSString stringWithFormat:message, args];

    va_end(args);
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"出错啦"
                                                    message:message
                                                   delegate:nil 
                                          cancelButtonTitle:@"好" 
                                          otherButtonTitles:nil]autorelease];
    
    [alert show];
}

+ (void) showMessage:(NSString *)message, ...
{
    va_list args;
    va_start(args, message);
    
    NSString* formattedMessage;
    message = formattedMessage = [NSString stringWithFormat:message, args];
    
    va_end(args);
    
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil 
                                          cancelButtonTitle:@"知道了" 
                                          otherButtonTitles:nil]autorelease];
    
    [alert show];
}

+ (void) showWaitNotification: (NSString *) message, ...
{   
    va_list args;
    va_start(args, message);
    
    NSString* formattedMessage;
    message = formattedMessage = [[NSString alloc] initWithFormat:message arguments:args];
    
    va_end(args);
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:message 
                                                     message:nil 
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    
    UIActivityIndicatorView *indicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
    [indicator startAnimating];
    [alert addSubview:indicator];
    
    //To be modified for Callback
    //[NSThread sleepForTimeInterval:1];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


@end
