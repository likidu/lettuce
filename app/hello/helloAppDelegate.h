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
#define kAppRedirectURI     @"http://open.weibo.com"

@class SinaWeibo;
@class SNViewController;
// ######################################################

@interface helloAppDelegate : NSObject <UIApplicationDelegate> {
    SinaWeibo *sinaweibo;
}

@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (strong, nonatomic) SNViewController *viewController;

@end
