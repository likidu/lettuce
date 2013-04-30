//
//  MonthlyBudgetView.h
//  woojuu
//
//  Created by Lee Rome on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"
#import "UIKit/UITextView.h"

@interface MonthlyBudgetView : UIViewController<NavigationItem, UITextFieldDelegate>

@property(nonatomic,retain) IBOutlet UITextField* budgetField;
@property(nonatomic,assign) BOOL goForward;

- (IBAction)onNext:(id)sender;
- (IBAction)onPrev:(id)sender;

@property(nonatomic,retain) NSMutableDictionary* navigationData;

@end
