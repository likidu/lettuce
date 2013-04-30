//
//  User.h
//  woojuu
//
//  Created by Liki Du on 4/16/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiboUser : NSObject

@property (nonatomic, retain) NSDictionary *accountInfo;
@property (nonatomic) BOOL isAuthorizeExpired;

- (id)init;
- (void)store:(NSDictionary *)accountInfo;
- (void)wipe;

@end
