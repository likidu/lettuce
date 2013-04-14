//
//  WoojuuAPIClient.m
//  woojuu
//
//  Created by Liki Du on 4/14/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "WoojuuAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kWoojuuAPIBaseURLString = @"http://localhost";

@implementation WoojuuAPIClient

+ (WoojuuAPIClient *)sharedClient {
    static WoojuuAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WoojuuAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWoojuuAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

@end
