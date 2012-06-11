//
//  WeiboAuthManager.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-30.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "RestKit/RestKit.h"
#import <Foundation/Foundation.h>

@interface WeiboAuthManager : NSObject <UIWebViewDelegate>

+ (BOOL) isAuthNeeded:(RKResponse*)response;

+ (void) showLoginPageFromController:(UIViewController*)parentController;

@end