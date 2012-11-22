//
//  UIViewController+UtilityExtension.h
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UtilityExtension)

+ (UIViewController*)instanceFromNib;
+ (UIViewController*)instanceFromNib:(NSString*)nibname;

@end
