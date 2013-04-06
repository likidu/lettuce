//
//  helloAppDelegate.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// ############## weibo #################################
// TODO denny
#define kAppKey             @"1948323577"
#define kAppSecret          @"a9a6ba85eca70e70c227914ba2405845"
#define kAppRedirectURI     @"http://open.weibo.com"
// ######################################################

@interface helloAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
