//
//  FirstViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddgetView.h"
#import "SettingView.h"
#import "MiddleViewController.h"

@interface FirstViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    BuddgetView *budgetView;
    SettingView *settingView;
    MiddleViewController *newTransactionView;
}

@property(nonatomic, retain) IBOutlet UILabel *budgetLabel;
@property(nonatomic, retain) IBOutlet UITableViewCell *transactionCell;
@property(nonatomic, retain) IBOutlet UITableViewCell *transactionHeaderCell;
@property(nonatomic, retain) IBOutlet UITableViewCell *transactionFooterCell;
@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property(nonatomic, retain) IBOutlet UILabel* savingLabel;
@property(nonatomic, retain) IBOutlet UITableView *transactionTable;
@property(nonatomic, retain) IBOutlet UIImageView* stampView;

- (IBAction)onChangeBudget:(id)sender;
- (IBAction)onSettings:(id)sender;

@property (nonatomic, retain) NSArray* todayExpenses;

@end
