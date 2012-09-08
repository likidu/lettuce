//
//  RKClientHelper.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface RKClientHelper : NSObject <RKRequestDelegate>

- (RKClientHelper *) initOnResponse: (void (^)(RKResponse *))onResponse
                      OnRequireAuth: (void (^)(void))onRequireAuth;

- (RKClientHelper *) initOnResponse: (void (^)(RKResponse *))onResponse
                      OnRequireAuth: (void (^)(void))onRequireAuth
                            onError: (void (^)(NSError *))onError
                          onTimeout: (void (^)(void))onTimeout;

@property (nonatomic, retain) void (^onRequireAuth)(void);
@property (nonatomic, retain) void (^onResponse)(RKResponse*);
@property (nonatomic, retain) void (^onError)(NSError*);
@property (nonatomic, retain) void (^onTimeout)(void);

@end
