//
//  ExpenseHistoryViewController.h
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"


@interface ExpenseHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, DateRangeResponder> {
}

@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property(nonatomic, retain) NSArray* dates;
@property(nonatomic, retain) NSDictionary* expenseData;
@property(nonatomic, retain) NSDictionary* totalData;

@property(nonatomic, retain) IBOutlet UITableViewCell* cellTemplate;

@end
