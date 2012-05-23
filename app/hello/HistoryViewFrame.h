//
//  HistoryViewFrame.h
//  woojuu
//
//  Created by Lee Rome on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryRootView.h"

#define KEY_EXPENSE_BY_YEAR                     @"ExpenseByYear"
#define KEY_EXPENSE_BY_YEAR_AND_CATEGORY        @"ExpenseByYearAndCategory"
#define KEY_EXPENSE_BY_CATEGORY                 @"ExpenseByCategory"
#define KEY_EXPENSE_BY_MONTH                    @"ExpenseByMonth"

@interface HistoryViewFrame : UIViewController 

@property(nonatomic,retain) UINavigationController* navController;

@end
