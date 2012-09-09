//
//  ConfigurationManager.m
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigurationManager.h"
 
@implementation ConfigurationManager

+ (NSDictionary *)getAllConfigurations{
    NSMutableDictionary *configurationDictionary = [[[NSMutableDictionary alloc]init]autorelease];
    [self AddElementToDictionary:configurationDictionary :REMINDER_SWITCH_KEY];
    [self AddElementToDictionary:configurationDictionary :REMINDER_TYPE_KEY];
    [self AddElementToDictionary:configurationDictionary :REMINDER_TIME_KEY];
    [self AddElementToDictionary:configurationDictionary :BACKUP_TIME_KEY];
    [self AddElementToDictionary:configurationDictionary :WEIBO_USERNAME_KEY];
    [self AddElementToDictionary:configurationDictionary :TRANSACTIONVIEW_STARTUP_KEY];
    [self AddElementToDictionary:configurationDictionary :PASSWORD_KEY];
    [self AddElementToDictionary:configurationDictionary :ACTIVE_PASSWORD_KEY];
    return configurationDictionary;
}

+ (void)AddElementToDictionary: (NSMutableDictionary *)dict: (NSString *)key{
    NSString *value = [[NSUserDefaults standardUserDefaults]stringForKey:key];
    [dict setValue:value forKey:key];
}
@end
