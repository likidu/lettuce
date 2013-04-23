//
//  WoojuuAPIClient.m
//  woojuu
//
//  Created by Liki Du on 4/14/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "WoojuuAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kWoojuuAPIBaseURLString = @"http://api.woojuu.cc";
static NSString * const kWoojuuAPIPathURLString = @"backup/";

@implementation WoojuuAPIClient

#pragma mark - singleton methods

+ (WoojuuAPIClient *)sharedClient {
    static WoojuuAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WoojuuAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWoojuuAPIBaseURLString]];
    });
    
    return _sharedClient;
}

#pragma mark - initWithBaseURL
// Overrides initWithBaseURL
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

- (void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock {
    NSData *uploadFile = nil;
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData *)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kWoojuuAPIPathURLString parameters:params
                                              constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
                                                     //TODO: attach file if needed
                                                     if (uploadFile) {
                                                         // Mime type could be "x-sqlite3"
                                                         [formData appendPartWithFileData:uploadFile name:@"db" fileName:@"db.sqlite" mimeType:@"application/octet-stream"];
                                                     }
                                                 }];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        //success
        NSLog(@"Response %@", response);
        completionBlock(response);
    }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         //failure
//                                         completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
                                     }];
}

@end
