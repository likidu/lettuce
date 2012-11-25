//
//  OverviewByYearViewController.h
//  woojuu
//
//  Created by Lee Rome on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@interface OverviewByYearViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DateRangeResponder>

@property(nonatomic,retain) IBOutlet UITableView* tableView;
@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,assign) id<ReportViewDelegate> delegate;

@property(nonatomic,retain) IBOutlet UILabel* totalBudgetLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalExpenseLabel;
@property(nonatomic,retain) IBOutlet UILabel* totalBalanceLabel;
@property(nonatomic,retain) IBOutlet UIView* summaryView;

@property(nonatomic,retain) NSDate* dayOfYear;
@property(nonatomic,retain) NSArray* yearData;
@property(nonatomic,retain) NSArray* budgetData;
@property(nonatomic,retain) NSArray* expenseData;
@property(nonatomic,retain) NSArray* balanceData;

@end
