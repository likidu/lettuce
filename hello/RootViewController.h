//
//  RootViewController.h
//  hello
//
//  Created by Rome Lee on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController {
    UIViewController* activeController;
}

- (IBAction)onToday:(id)sender;
- (IBAction)onAddExpense:(id)sender;
- (IBAction)onHistory:(id)sender;

@property (nonatomic, retain) IBOutlet UIViewController* todayController;
@property (nonatomic, retain) IBOutlet UIViewController* addExpenseController;
@property (nonatomic, retain) IBOutlet UIViewController* historyController;

@property (nonatomic, retain) IBOutlet UIView* tabPanel;

@property (nonatomic, retain) IBOutlet UIButton* todayButton;
@property (nonatomic, retain) IBOutlet UIButton* historyButton;

@end
