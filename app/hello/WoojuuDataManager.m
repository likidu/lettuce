//
//  WoojuuDataManager.m
//  woojuu
//
//  Created by Liangying Wei on 9/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WoojuuDataManager.h"
#import "WoojuuData.h"
#import "ConfigurationManager.h"

#define DATABASE_FILENAME @"db.sqlite"
#define CONFIGURATION_FILENAME @"Preferences/cc.woojuu.book.plist"

@implementation WoojuuDataManager
+ (WoojuuData *)getWoojuuData{
    NSDictionary *configuration =  [self getConfigurationData];
    NSData *database = [self getDatabaseFile];
    return [[WoojuuData alloc]initWithName:configuration :database];
}

+ (void)setDataToWoojuu:(WoojuuData *)data{
    //replace the file or replace the DATA
}

+ (NSDictionary *)getConfigurationData{    
    return [ConfigurationManager getAllConfigurations];
}

+ (NSData *)getDatabaseFile{  
    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *configPath = [libraryPath stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    NSFileManager *manager = [NSFileManager defaultManager]; 
    return [manager contentsAtPath:configPath];
}
@end
