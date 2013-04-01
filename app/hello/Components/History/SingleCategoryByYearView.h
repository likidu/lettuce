//
//  SingleCategoryByYearView.h
//  woojuu
//
//  Created by Lee Rome on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@interface SingleCategoryByYearView : UIViewController<UITableViewDelegate, UITableViewDataSource, ViewOptionResponder>

@property(nonatomic,retain) IBOutlet UITableViewCell* cellTemplate;
@property(nonatomic,retain) IBOutlet UITableView* table;
@property(nonatomic,retain) IBOutlet UILabel* navigationItemView;

@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic,retain) NSArray* months;
@property(nonatomic,retain) NSArray* numbers;
@property(nonatomic,retain) NSArray* amounts;
@property(nonatomic,assign) int categoryId;

@end
