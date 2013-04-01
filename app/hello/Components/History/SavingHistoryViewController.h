//
//  SavingHistoryViewController.h
//  woojuu
//
//  Created by Rome Lee on 11-8-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"


@interface SavingHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, DateRangeResponder> {
    
}

// set to nil at viewDidUnload
@property(nonatomic,retain) IBOutlet UITableView* table;
@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;

// set to nil at dealloc
@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic,retain) NSArray* dates;
@property(nonatomic,retain) NSArray* budgets;
@property(nonatomic,retain) NSDictionary* totals;

@end
