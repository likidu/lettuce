//
//  MonthViewRoot.h
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewByCategoryViewController.h"
#import "ExpenseHistoryViewController.h"

@interface MonthViewRoot : UIViewController<DateRangeResponder, ReportViewDelegate>

@property(nonatomic,retain) IBOutlet UIView* tableViewPlaceHolder;
@property(nonatomic,retain) IBOutlet UILabel* navigationItemView;
@property(nonatomic,retain) OverviewByCategoryViewController* overviewByCategory;
@property(nonatomic,retain) ExpenseHistoryViewController* overviewByDate;
@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,retain) IBOutlet UIButton* viewByCategoryButton;
@property(nonatomic,retain) IBOutlet UIButton* viewByDateButton;
@property(nonatomic,retain) IBOutlet UILabel* viewByDateLabel;
@property(nonatomic,retain) IBOutlet UILabel* viewByCategoryLabel;

- (IBAction)onViewByCategory;
- (IBAction)onViewByDate;

@end
