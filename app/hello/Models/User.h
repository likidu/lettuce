//
//  User.h
//  woojuu
//
//  Created by Liki Du on 4/16/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, retain) NSDictionary *accountInfo;
@property (nonatomic) BOOL isAuthorizeExpired;
@property (nonatomic) BOOL isAuthorized;

- (id)init;
- (void)update:(NSDictionary *)accountInfo;

@end
