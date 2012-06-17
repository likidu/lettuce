//
//  HistoryRootView.h
//  woojuu
//
//  Created by Lee Rome on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewByYearViewController.h"
#import "OverviewByCategoryViewController.h"

@interface HistoryRootView : UIViewController

@property(nonatomic,retain) OverviewByYearViewController* overviewByMonth;
@property(nonatomic,retain) OverviewByCategoryViewController* overviewByCategory;
@property(nonatomic,retain) IBOutlet UIView* tableViewPlaceHolder;
@property(nonatomic,retain) IBOutlet UIButton* viewByMonthButton;
@property(nonatomic,retain) IBOutlet UIButton* viewByCategoryButton;

- (IBAction)onViewByMonth;
- (IBAction)onViewByCategory;

@end
