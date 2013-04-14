//
//  WoojuuAPIClient.h
//  woojuu
//
//  Created by Liki Du on 4/14/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "AFHTTPClient.h"

@interface WoojuuAPIClient : AFHTTPClient

+ (WoojuuAPIClient *)sharedClient;

@end
