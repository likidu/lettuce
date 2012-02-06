//
//  DbTransitionManager.m
//  woojuu
//
//  Created by Rome Lee on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DbTransitionManager.h"
#import "Database.h"

#define COLUMN_NAME_LATITUDE                @"Latitude"
#define COLUMN_NAME_LONGITUDE               @"Longitude"
#define COLUMN_NAME_USELOCATION             @"UseLocation"

@implementation DbTransitionManager

+ (void)migrateExpenseTable {
    Database* db = [Database instance];
    // upgrade for location
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

+ (void)migrateToMonthlyPlan {
    // upgrade for monthly plan
    Database* db = [Database instance];
    NSArray* results = [db execute:@"PRAGMA table_info(monthly_plan);"];
    if (results.count == 0) {
        [db execute:@"CREATE TABLE IF NOT EXISTS monthly_plan (PlanId INTEGER PRIMARY KEY AUTOINCREMENT, Income REAL NOT NULL DEFAULT 0.0, Budget REAL NOT NULL DEFAULT 0.0, Date DATE NOT NULL DEFAULT (DATE('NOW')))"];
    }
}

+ (void)migrateToNewCategories {
    // upgrade to new categories
    Database* db = [Database instance];
    NSString* sqlText = [NSString stringWithFormat:@"select * from category where CategoryId = %d", FIXED_EXPENSE_CATEGORY_ID_START];
    NSArray* results = [db execute: sqlText];
    if (results.count == 0) {
        // drop the old table and copy the new table from the template database
        [db execute:@"DROP TABLE Category"];
    }
}

+ (void)migrateToCurrentVersion {
    [DbTransitionManager migrateExpenseTable];
    [DbTransitionManager migrateToMonthlyPlan];
    [DbTransitionManager migrateToNewCategories];
}

@end
