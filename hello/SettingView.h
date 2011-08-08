//
//  SettingView.h
//  hello
//
//  Created by Rome Lee on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingView : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

@property(nonatomic, retain) IBOutlet UITableView* settingTableView;
@property(nonatomic, retain) IBOutlet UISwitch* yesNoSwitch;

- (IBAction)onOk:(id)sender;
- (IBAction)onSwitch;

@property(nonatomic, retain) UIImage* imgAbout;
@property(nonatomic, retain) UIImage* imgStartup;
@property(nonatomic, retain) UIImage* imgBudget;

@end
