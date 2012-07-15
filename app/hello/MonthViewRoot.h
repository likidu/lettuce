//
//  MonthViewRoot.h
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewByCategoryViewController.h"

@interface MonthViewRoot : UIViewController<DateRangeResponder, ReportViewDelegate>

@property(nonatomic,retain) IBOutlet UIView* tableViewPlaceHolder;
@property(nonatomic,retain) IBOutlet UILabel* navigationItemView;
@property(nonatomic,retain) OverviewByCategoryViewController* overviewByCategory;
@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;

@end
