//
//  WoojuuAPIClient.m
//  woojuu
//
//  Created by Liki Du on 4/14/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "WoojuuAPIClient.h"
#import "AFJSONRequestOperation.h"

static NSString *const kWoojuuAPIBaseURLString = @"http://www.woojuu.cc:8082";
static NSString *const kWoojuuAPIPathString = @"/backup";

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

#define MIME_TYPE @"application/x-sqlite3" // Alternative: application/octet-stream

- (void)commandWithParams:(NSMutableDictionary *)params onCompletion:(JSONResponseBlock)completionBlock {
    NSData *uploadFile = nil;
    if ([params objectForKey:@"file"]) {
        uploadFile = (NSData *)[params objectForKey:@"file"];
        [params removeObjectForKey:@"file"];
    }

    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:kWoojuuAPIPathString parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData>formData) {
        //Attach file if needed
        if (uploadFile) {
            [formData appendPartWithFileData:uploadFile name:@"file" fileName:@"db.sqlite" mimeType:MIME_TYPE];
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
                                         NSLog(@"Error!");
                                         completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
                                     }];
    [operation start];
}

@end
