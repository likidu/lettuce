//
//  ExpenseHistoryViewController.h
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExpenseHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
}

+ (ExpenseHistoryViewController*)instance;
+ (void)dispose;

@property(nonatomic, retain) NSDate* startDate;
@property(nonatomic, retain) NSDate* endDate;
@property(nonatomic, retain) NSArray* dates;
@property(nonatomic, retain) NSDictionary* expenseDictionary;

@property(nonatomic, retain) IBOutlet UITableViewCell* expenseCell;
@property(nonatomic, retain) IBOutlet UITableViewCell* headerCell;
@property(nonatomic, retain) IBOutlet UITableViewCell* footerCell;

- (void)reload;

@end
