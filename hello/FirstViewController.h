//
//  FirstViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BudgetView.h"
#import "SettingView.h"
#import "MiddleViewController.h"

@interface FirstViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    BudgetView *budgetView;
    SettingView *settingView;
    MiddleViewController *newTransactionView;
}

@property(nonatomic, retain) IBOutlet UILabel *budgetLabel;
@property(nonatomic, retain) IBOutlet UITableViewCell *expenseCell;
@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property(nonatomic, retain) IBOutlet UILabel* savingLabel;
@property(nonatomic, retain) IBOutlet UITableView *transactionTable;
@property(nonatomic, retain) IBOutlet UIImageView* stampView;

- (IBAction)onChangeBudget:(id)sender;
- (IBAction)onSettings:(id)sender;

@property (nonatomic, retain) NSArray* todayExpenses;

@end
