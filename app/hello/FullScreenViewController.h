//
//  FullScreenViewController.h
//  woojuu
//
//  Created by Lee Rome on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FullScreenViewControllerDelegate <NSObject>

@optional
- (void)backgroundViewTapped;
- (BOOL)shouldDismissOnBackgroundViewTapped;
- (void)dismissed;

@end

@interface FullScreenViewController : UIViewController

@property(nonatomic,assign) id<FullScreenViewControllerDelegate> delegate;
- (void)presentView:(UIView*)view;
- (void)dismiss;

@end
