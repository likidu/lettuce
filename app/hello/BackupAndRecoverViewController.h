//
//  BackupAndRecoverViewController.h
//  woojuu
//
//  Created by Liangying Wei on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackupAndRecoverViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    
}

@property (retain, nonatomic) IBOutlet UITableView *backupAndRestore;

@property(nonatomic, retain) UIImage* imgBackup;
@property(nonatomic, retain) UIImage* imgRestore;

+ (BOOL)isUserLoggedIn;

+ (BackupAndRecoverViewController *) instance;
@end

