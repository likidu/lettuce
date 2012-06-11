//
//  RKClientHelper.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "WeiboAuthManager.h"
#import "RKClientHelper.h"
#import "UIAlertView+Helper.h"

@implementation RKClientHelper

@synthesize onResponse;
@synthesize onRequireAuth;
@synthesize onError;
@synthesize onTimeout;

void (^defaultOnError)(NSError*) = ^(NSError* err)
{
    [UIAlertView showError:[err description]];
};

void (^defaultOnTimeout)(void) = ^(void)
{
    [UIAlertView showError:@"连接超时，稍候再试吧。"];
};

- (RKClientHelper *) initOnResponse:(void (^)(RKResponse *))responseHandler
                      OnRequireAuth:(void (^)(void))authHandler
{
    self = [super init];
    
    if (self)
    {
        self.onResponse = responseHandler;
        self.onRequireAuth = authHandler;
        self.onError    = defaultOnError;
        self.onTimeout  = defaultOnTimeout;
    }
    
    return self;
}

- (RKClientHelper *) initOnResponse:(void (^)(RKResponse *))responseHandler 
                      OnRequireAuth:(void (^)(void))authHandler
                            onError:(void (^)(NSError *))errorHandler 
                          onTimeout:(void (^)(void))timeoutHandler
{
    self = [super init];
    
    if (self)
    {
        self.onResponse = responseHandler;
        self.onRequireAuth = authHandler;
        self.onError    = errorHandler;
        self.onTimeout  = timeoutHandler;
    }
    
    return self;
}

bool isAuthNeeded(RKResponse* response)
{
    return response.statusCode == 401;
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([WeiboAuthManager isAuthNeeded:response])
    {
        onRequireAuth();
    }
    else
    {
        onResponse(response);
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    onError(error);
}

- (void)requestDidTimeout:(RKRequest *)request
{
    onTimeout();
}

@end