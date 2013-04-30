//
//  WoojuuAPIClient.h
//  woojuu
//
//  Created by Liki Du on 4/14/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface WoojuuAPIClient : AFHTTPClient

+ (WoojuuAPIClient *)sharedClient;

// send an API command to the server
- (void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock;

@end
