//
//  NavigationProtocol.h
//  woojuu
//
//  Created by Lee Rome on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationController <NSObject>

- (void)forward;
- (void)backward;

@end

@protocol NavigationItem <NSObject>

@property(nonatomic,assign) id<NavigationController> controller;
- (void)setData:(NSMutableDictionary*)data;

@end