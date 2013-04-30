//
//  MonthlyIncomeView.h
//  woojuu
//
//  Created by Lee Rome on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"

@interface MonthlyIncomeView : UIViewController<NavigationItem>

@property(nonatomic,retain) IBOutlet UITextField* textView;
@property(nonatomic,retain) NSMutableDictionary* navigationData;

- (IBAction)onNext:(id)sender;

@end
