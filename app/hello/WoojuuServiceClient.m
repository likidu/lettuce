//
//  WoojuuServiceClient.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-5-23.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "WoojuuServiceClient.h"
#import "RKClient+Callback.h"
#import "UIAlertView+Helper.h"

@implementation WoojuuServiceClient

NSString* getAppVersion()
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"woojuu-Info" ofType:@"plist"];
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    NSString* appVersion = [[dict objectForKey:@"CFBundleVersion"] stringValue];
    return appVersion;
}

+(void) getBackupVersionAsync:(void (^)(NSString*))onSuccess
{
    [[RKClient sharedClient] get:@"/my/backup_version/v1.0/" 
                      onResponse:^(RKResponse* response)
                                {
                                    if (response.statusCode == 200)
                                    {
                                        onSuccess(response.bodyAsString);
                                    }
                                    else
                                    {
                                        [UIAlertView showError:@"服务器错误，请稍候再试。错误码：%@", response.statusCode];
                                    }
                                }];
}

+(void) setBackupVersion:(int)version Async:(void (^)(void))onSuccess
{
    NSMutableDictionary<RKRequestSerializable>* params = 
    [NSDictionary dictionaryWithObjectsAndKeys:@"version", version, 
                                               @"app_version", getAppVersion(), nil];
    
    [[RKClient sharedClient] post:@"/my/backup_version/v1.0/" 
                           params:params 
                         onResponse:^(RKResponse* response)
                                 {
                                     if (response.statusCode == 200)
                                     {
                                         onSuccess();
                                     }
                                     else
                                     {
                                         [UIAlertView showError:@"服务器错误，请稍候再试。错误码：%@", response.statusCode];
                                     }
                                 }];
}

+(void) getBackupUrlAsync:(void (^)(NSString*))onSuccess
{
    [[RKClient sharedClient] get:@"/my/backup_url/v1.0/"
                      onResponse:^(RKResponse* response)
                             {
                                 if (response.statusCode == 200)
                                 {
                                     onSuccess(response.bodyAsString);
                                 }
                                 else
                                 {
                                     [UIAlertView showError:@"服务器错误，请稍候再试。错误码：%@", response.statusCode];
                                 }
                             }];
}

+(void) getRestoreUrlAsync:(void (^)(NSString*))onSuccess
{
    [[RKClient sharedClient] get:@"/my/restore_url/v1.0/"
                      onResponse:^(RKResponse* response)
                             {
                                 if (response.statusCode == 200)
                                 {
                                     onSuccess(response.bodyAsString);
                                 }
                                 else
                                 {
                                     [UIAlertView showError:@"服务器错误，请稍候再试。错误码：%@", response.statusCode];
                                 }
                             }];
}

@end
