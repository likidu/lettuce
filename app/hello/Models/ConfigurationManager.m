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
    NSMutableDictionary *configurationDictionary = [NSMutableDictionary dictionary];
    [self AddElementToDictionary:configurationDictionary withKey:REMINDER_SWITCH_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:REMINDER_TYPE_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:REMINDER_TIME_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:BACKUP_TIME_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:TRANSACTIONVIEW_STARTUP_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:PASSWORD_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:ACTIVE_PASSWORD_KEY];
    [self AddElementToDictionary:configurationDictionary withKey:WEIBO_ACCOUNT_KEY];
    return configurationDictionary;
}

+ (void)AddElementToDictionary:(NSMutableDictionary *)dict withKey:(NSString *)key{
    NSString *value = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    [dict setValue:value forKey:key];
}
@end
