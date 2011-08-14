//
//  ExpenseHistoryByAmountViewController.h
//  woojuu
//
//  Created by Rome Lee on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@interface ExpenseHistoryByAmountViewController : UIViewController<DateRangeResponder> {
    
}

+ (ExpenseHistoryByAmountViewController*)createInstance;

@property(nonatomic,retain) IBOutlet UITableView* tableView;
@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic,retain) NSArray* expenses;

@end
