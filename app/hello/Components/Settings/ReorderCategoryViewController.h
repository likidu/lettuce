//
//  ReorderCategoryViewController.h
//  woojuu
//
//  Created by Liangying Wei on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReorderCategoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *categoryTableView;
@property (retain, nonatomic) NSMutableArray* categoryArray;
@property (retain, nonatomic) NSMutableArray* topCategoryArray;

@end
