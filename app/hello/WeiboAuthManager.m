//
//  WeiboAuthManager.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-30.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "constants.h"
#import "WeiboAuthManager.h"
#import "WebViewController.h"

@implementation WeiboAuthManager

+ (BOOL)isAuthNeeded:(RKResponse *)response
{
    return response.statusCode == 401; // unauthorized
}

+ (void)showLoginPageFromController:(UIViewController *)parentController
{    
    // TODO: Get domain name from config file.
    NSString* url = [NSString stringWithFormat:@"%@login/v1.0/", apiBaseURL];
    
    WebViewController* webViewController = [[WebViewController alloc] initWithURL:url];
    
    [parentController presentViewController:webViewController animated:false completion:nil];
    [webViewController release];
}

@end
