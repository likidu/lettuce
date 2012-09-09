//
//  ServiceUtility.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "RestKit/RestKit.h"
#import <Foundation/Foundation.h>

@interface RKClient (Callback)

- (void(^)(void))getAuthHandler;

- (id)initWithBaseURL:(NSString *)baseURL authHandler:(void (^)(void))authHandler;

- (void) get:(NSString*)resourcePath 
  onResponse:(void (^)(RKResponse*))onResponse;

- (void) post:(NSString*)resourcePath
       params:(NSObject<RKRequestSerializable> *)params 
   onResponse:(void (^)(RKResponse*))onResponse;

- (void) put:(NSString*)resourcePath 
  onResponse:(void (^)(RKResponse*))onResponse;

@end
