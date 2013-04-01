//
//  NewFeaturesView.h
//  woojuu
//
//  Created by Lee Rome on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"

@interface NewFeaturesView : UIViewController<NavigationItem>

- (IBAction)onNext:(id)sender;
- (IBAction)onPrev:(id)sender;

@end
