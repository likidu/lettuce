//
//  CloudManager.h
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudManager : NSObject
+ (void)backupDataToCloudAsyc:(NSString *)backupUrl: (NSObject *)data :(void (^)(NSString*))onSuccess;
+ (void)restoreDataFromCloudAsyc:(NSString *)restoreUrl: (NSObject *)data :(void (^)(NSString*))onSuccess;
@end
