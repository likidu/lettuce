//
//  UserAccountViewController.h
//  woojuu
//
//  Created by Liangying Wei on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountViewController : UIViewController<UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UIWebView *sinaWebView;
@property (retain, nonatomic) IBOutlet UIView *loginView;
@property (retain, nonatomic) IBOutlet UIView *backupView;

@property (retain, nonatomic) IBOutlet UITableView *backupAndRestore;
@property (retain, nonatomic) IBOutlet UILabel *labelStatus;
@property(nonatomic, retain) UIImage *imgBackup;
@property(nonatomic, retain) UIImage *imgRestore;

+ (UserAccountViewController *) instance;
+ (BOOL)isUserLoggedIn;

@end
