//
//  BackupAndRecoverViewController.h
//  woojuu
//
//  Created by Liangying Wei on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface BackupAndRecoverViewController : UIViewController<UITableViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, UITableViewDataSource>{
    
}

@property (retain, nonatomic) IBOutlet UITableView *backupAndRestore;
@property (retain, nonatomic) IBOutlet UILabel *labelStatus;
@property(nonatomic, retain) UIImage* imgBackup;
@property(nonatomic, retain) UIImage* imgRestore;

+ (BOOL)isUserLoggedIn;

+ (BackupAndRecoverViewController *) instance;
@end

