//
//  helloAppDelegate.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// #################  Mixpannel #########################
#define MIXPANEL_TOKEN @"03caa3c6e77bab5ef3ab8dfdd8ef3fac"
// ######################################################


// ############## weibo #################################
// TODO denny
#define kAppKey             @"1948323577"
#define kAppSecret          @"a9a6ba85eca70e70c227914ba2405845"
#define kAppRedirectURI     @"http://baidu.com"

#import "BackupAndRecoverViewController.h"

@class SinaWeibo;

@interface helloAppDelegate : NSObject <UIApplicationDelegate> {
    SinaWeibo *sinaweibo;
}
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BackupAndRecoverViewController *viewController;

@end
