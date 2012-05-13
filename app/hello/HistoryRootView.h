//
//  HistoryRootView.h
//  woojuu
//
//  Created by Lee Rome on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewByYearViewController.h"

@interface HistoryRootView : UIViewController

@property(nonatomic,retain) OverviewByYearViewController* overviewByYear;
@property(nonatomic,retain) IBOutlet UIView* tableViewPlaceHolder;

@end
