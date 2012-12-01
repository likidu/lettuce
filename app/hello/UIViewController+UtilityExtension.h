//
//  UIViewController+UtilityExtension.h
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerDelegate <NSObject>

@optional

- (void)didDismissViewController:(UIViewController*)viewController;
- (void)didPresentViewController:(UIViewController*)viewController;

@end

@interface UIViewController (UtilityExtension)

+ (UIViewController*)instanceFromNib;
+ (UIViewController*)instanceFromNib:(NSString*)nibName;

@property(nonatomic,assign) id<UIViewControllerDelegate> delegate;

@end

