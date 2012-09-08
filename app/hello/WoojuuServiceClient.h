//
//  WoojuuServiceClient.h
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WoojuuServiceClient : NSObject

+(void) getBackupVersionAsync:(void (^)(NSString*))onSuccess;

+(void) setBackupVersionAsync:(void (^)(void))onSuccess;

+(void) getBackupUrlAsync:(void (^)(NSString*))onSuccess;

+(void) getRestoreUrlAsync:(void (^)(NSString*))onSuccess;

@end
