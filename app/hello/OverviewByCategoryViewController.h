//
//  OverviewByCategoryViewController.h
//  woojuu
//
//  Created by Lee Rome on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@protocol OverviewByCategoryViewControllerDelegate <NSObject>

@required
- (void)pickedCategory:(int)categoryId;

@end

@interface OverviewByCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, DateRangeResponder>

@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,retain) IBOutlet UITableView* table;

@property(nonatomic,retain) NSArray* categories;
@property(nonatomic,retain) NSArray* numbers;
@property(nonatomic,retain) NSArray* amounts;

@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;

@property(nonatomic,assign) id<OverviewByCategoryViewControllerDelegate> delegate;

@end
