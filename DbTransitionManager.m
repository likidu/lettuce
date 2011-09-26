//
//  DbTransitionManager.m
//  woojuu
//
//  Created by Rome Lee on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DbTransitionManager.h"
#import "Database.h"

#define COLUMN_NAME_LATITUDE @"Latitude"
#define COLUMN_NAME_LONGITUDE @"Longitude"
#define COLUMN_NAME_USELOCATION @"UseLocation"

@implementation DbTransitionManager

+ (void)migrateToCurrentVersion {
    Database* db = [Database instance];
    NSArray* results = [db execute:@"PRAGMA table_info(expense);"];
    BOOL foundLatitude = NO, foundLongitude = NO, foundUseLocation = NO;
    for (NSDictionary* record in results) {
        NSString* columnName = [record objectForKey:@"name"];
        if (!columnName)
            continue;
        if ([columnName compare:COLUMN_NAME_LATITUDE options:NSCaseInsensitiveSearch] == NSOrderedSame)
            foundLatitude = YES;
        if ([columnName compare:COLUMN_NAME_LONGITUDE options:NSCaseInsensitiveSearch] == NSOrderedSame)
            foundLongitude = YES;
        if ([columnName compare:COLUMN_NAME_USELOCATION options:NSCaseInsensitiveSearch] == NSOrderedSame)
            foundUseLocation = YES;
    }
    
    if (!foundUseLocation)
        [db execute:@"ALTER TABLE Expense ADD COLUMN UseLocation BOOLEAN NOT NULL DEFAULT FALSE"];
    if (!foundLatitude)
        [db execute:@"ALTER TABLE Expense ADD COLUMN Latitude REAL NOT NULL DEFAULT 0.0"];
    if (!foundLongitude)
        [db execute:@"ALTER TABLE Expense ADD COLUMN Longitude REAL NOT NULL DEFAULT 0.0"];
}

@end
