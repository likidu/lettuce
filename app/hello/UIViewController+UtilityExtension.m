//
//  UIViewController+UtilityExtension.m
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+UtilityExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (UtilityExtension)

+ (UIViewController *)instanceFromNib {
    NSString* className = [NSString stringWithCString:class_getName(self) encoding:NSASCIIStringEncoding];
    UIViewController* viewController = [[[self alloc]initWithNibName:className bundle:[NSBundle mainBundle]]autorelease];
    return viewController;
}

@end
