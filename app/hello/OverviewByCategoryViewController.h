//
//  OverviewByCategoryViewController.h
//  woojuu
//
//  Created by Lee Rome on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@interface OverviewByCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DateRangeResponder>

@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,retain) IBOutlet UITableView* table;

@property(nonatomic,retain) NSArray* categories;
@property(nonatomic,retain) NSArray* numbers;
@property(nonatomic,retain) NSArray* amounts;

@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,assign) id<ReportViewDelegate> delegate;

@end
