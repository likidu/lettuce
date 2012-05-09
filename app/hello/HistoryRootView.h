//
//  HistoryRootView.h
//  woojuu
//
//  Created by Lee Rome on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryRootView : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,retain) NSArray* yearData;
@property(nonatomic,retain) IBOutlet UITableView* tableView;
@property(nonatomic,retain) IBOutlet UIView* summaryView;

@end
