//
//  helloAppDelegate.m
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "helloAppDelegate.h"
#import "Database.h"
#import "CategoryManager.h"
#import "ExpenseManager.h"
#import "RootViewController.h"
#import "LocationManager.h"
#import "FlurryAnalytics.h"
#import "PasscodeView.h"
#import "ConfigurationManager.h"

void uncaughtExceptionHandler(NSException* exception) {
    [FlurryAnalytics logError:@"Uncaught Exception" message:@"" exception:exception];
}
                              
@implementation helloAppDelegate

@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // log all unhandled exceptions using Flurry
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    [self.window makeKeyAndVisible];
    
    [application setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
    
    [FlurryAnalytics startSession:@"U39ZXPZ2BCQEWCEH3HN1"];
    
    // setup location service
    //[LocationManager tryUpdateLocation];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //[LocationManager tryPause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    //[LocationManager tryResume];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:TRANSACTIONVIEW_STARTUP_KEY]) {
        UIApplication* app = [UIApplication sharedApplication];
        RootViewController* vc = (RootViewController*)app.keyWindow.rootViewController;
        [vc presentAddTransactionDialog:nil];
    }
    
    // test code
    [PasscodeView setPasscode];
    
    // stop user here
    [PasscodeView checkPasscode];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    //[LocationManager tryTerminate];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
