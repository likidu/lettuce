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
#import "FullScreenViewController.h"

@interface HistoryRootView : UIViewController<FullScreenViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ReportViewDelegate>

@property(nonatomic,retain) OverviewByYearViewController* overviewByMonth;
@property(nonatomic,retain) OverviewByCategoryViewController* overviewByCategory;
@property(nonatomic,retain) IBOutlet UIView* tableViewPlaceHolder;
@property(nonatomic,retain) IBOutlet UIButton* viewByMonthButton;
@property(nonatomic,retain) IBOutlet UIButton* viewByCategoryButton;
@property(nonatomic,retain) IBOutlet UIButton* navigationButton;
@property(nonatomic,retain) IBOutlet UIPickerView* yearPicker;
@property(nonatomic,retain) IBOutlet UILabel* viewByMonthLabel;
@property(nonatomic,retain) IBOutlet UILabel* viewByCategoryLabel;

- (IBAction)onViewByMonth;
- (IBAction)onViewByCategory;
- (IBAction)onPickYear;

@end
