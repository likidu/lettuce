//
//  SecondViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlotView.h"


@interface SecondViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>{

}

@property(nonatomic, retain) NSArray* dates;
@property(nonatomic, retain) NSMutableDictionary* transactionCache;

@property(nonatomic, retain) IBOutlet UITableViewCell* transactionCell;
@property(nonatomic, retain) IBOutlet UITableView* transactionView;
@property(nonatomic, retain) IBOutlet UIView* headerView;
@property(nonatomic, retain) IBOutlet UIView* footerView;
@property(nonatomic, retain) IBOutlet UIButton* uiDate;

@property(nonatomic, retain) IBOutlet UIView* datePicker;
@property(nonatomic, retain) IBOutlet UIView* plotView;

- (IBAction) onEdit:(id)sender;
- (IBAction) onPickDate:(id)sender;
- (void)onEndPickDate:(NSDate*)day;

@end
