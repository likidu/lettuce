//
//  ServiceUtility.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <objc/runtime.h>
#import "RKClientHelper.h"
#import "RKClient+Callback.h"

static void *authHandlerKey;

@implementation RKClient (Callback)

- (id)initWithBaseURL:(NSString *)baseURL authHandler:(void (^)(void))authHandler
{
    if (self)
    {
        self = [self initWithBaseURL:baseURL];
        
        // property is not supported for class extension =,=
        // add auth handler for later use.
        // http://stackoverflow.com/questions/8733104/objective-c-property-in-category
        objc_setAssociatedObject(self, &authHandlerKey, authHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return self;
}

- (void (^)(void))getAuthHandler
{
    return objc_getAssociatedObject(self, authHandlerKey);
}

- (void) get:(NSString*)resourcePath 
  onResponse:(void (^)(RKResponse*))onResponse
{
    RKClientHelper* helper = [[[RKClientHelper alloc] initOnResponse:onResponse OnRequireAuth:[self getAuthHandler]] autorelease];
    
    [self get:resourcePath delegate:helper];
}

- (void) post:(NSString *)resourcePath 
       params:(NSObject<RKRequestSerializable> *)params 
   onResponse:(void (^)(RKResponse *))onResponse
{
    RKClientHelper* helper = [[[RKClientHelper alloc] initOnResponse:onResponse OnRequireAuth:[self getAuthHandler]] autorelease];
    
    [self post:resourcePath params:params delegate:helper];
}

- (void) put:(NSString*)resourcePath 
  onResponse:(void (^)(RKResponse*))onResponse
{
    // TODO: To implement.
}

@end
