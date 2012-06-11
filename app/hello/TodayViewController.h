//
//  TodayViewController.h
//  woojuu
//
//  Created by Lee Rome on 11-12-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressView.h"
#import "SettingView.h"

@interface TodayViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) IBOutlet SettingView* settingView;
@property(nonatomic,retain) IBOutlet ProgressView* progressView;
@property(nonatomic,retain) IBOutlet UILabel* monthlyBudgetLabel;
@property(nonatomic,retain) IBOutlet UILabel* monthlyExpenseLabel;
@property(nonatomic,retain) IBOutlet UILabel* monthlyBalanceLabel;
@property(nonatomic,retain) IBOutlet UILabel* todayExpenseLabel;
@property(nonatomic,retain) IBOutlet UITableView* expenseTable;
@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,retain) IBOutlet UILabel* dateLabel;

@property(nonatomic,retain) NSArray* expenses;

- (IBAction)onSettings:(id)sender;

@end
