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
#define COLUMN_NAME_CATEGORYICON            @"CIconResName"

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
    Database* db = [Database instance];
    // upgrade for location
    NSArray* categoryResults = [db execute:@"PRAGMA table_info(category);"];
    BOOL foundCategoryResource = NO;
    for (NSDictionary* record in categoryResults) {
        NSString* columnName = [record objectForKey:@"name"];
        if (!columnName)
            continue;
        if ([columnName compare:COLUMN_NAME_CATEGORYICON options:NSCaseInsensitiveSearch] == NSOrderedSame)
            foundCategoryResource = YES;
    }
    
    NSString* sqlText = [NSString stringWithFormat:@"select * from category where CategoryId = %d", FIXED_EXPENSE_CATEGORY_ID_START];
    NSArray* results = [db execute: sqlText];
    if (results.count == 0 || !foundCategoryResource) {
        // drop the old table and copy the new table from the template database
        [db execute:@"DROP TABLE Category"];
        [db execute:@"CREATE TABLE category (CategoryId INTEGER PRIMARY KEY AUTOINCREMENT, CategoryName TEXT, IconResName TEXT, IsActive BOOLEAN DEFAULT True, DisplayId INTEGER, ParentId INTEGER NOT NULL DEFAULT 0, HIconResName TEXT, SIconResName TEXT, CIconResName TEXT)"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (1,'日常支出','',1,5,0,'','','')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (2,'精神生活','',0,10,0,'','','')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (3,'日常生活','',0,15,0,'','','')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (4,'早午晚餐','dining.png',1,20,1,'dining_h.png','dining_s.png','dining_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (5,'咖啡饮料','beverage.png',1,25,1,'beverage_h.png','beverage_s.png','beverage_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (6,'零食水果','snack.png',1,30,1,'snack_h.png','snack_s.png','snack_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (7,'香烟酒水','drink.png',1,35,1,'drink_h.png','drink_s.png','drink_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (8,'衣服裤子','clothes.png',1,40,1,'clothes_h.png','clothes_s.png','clothes_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (9,'鞋帽包包','shoes.png',1,45,1,'shoes_h.png','shoes_s.png','shoes_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (10,'首饰饰品','accesories.png',1,50,1,'accesories_h.png','accesories_s.png','accesories_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (11,'数码家电','appliance.png',1,55,1,'appliance_h.png','appliance_s.png','appliance_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (12,'休闲玩乐','lesure.png',1,60,1,'lesure_h.png','lesure_s.png','lesure_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (13,'运动健身','workout.png',1,65,1,'workout_h.png','workout_s.png','workout_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (14,'旅游度假','touring.png',0,70,1,'touring_h.png','touring_s.png','touring_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (15,'宠物','pet.png',1,75,1,'pet_h.png','pet_s.png','pet_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (16,'书报杂志','reading.png',1,80,1,'reading_h.png','reading_s.png','reading_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (17,'培训进修','learning.png',0,85,1,'learning_h.png','learning_s.png','learning_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (18,'个人爱好','hobby.png',1,90,1,'hobby_h.png','hobby_s.png','hobby_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (19,'日常用品','living.png',1,95,1,'living_h.png','living_s.png','living_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (20,'网络通信','network.png',0,100,1,'network_h.png','network_s.png','network_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (21,'公共交通','transportation.png',1,105,1,'transportation_h.png','transportation_s.png','transportation_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (22,'打车','taxi.png',1,110,1,'taxi_h.png','taxi_s.png','taxi_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (23,'私车费用','automobile.png',1,115,1,'automobile_h.png','automobile_s.png','automobile_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (24,'美发美容','beauty.png',1,120,1,'beauty_h.png','beauty_s.png','beauty_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (25,'医疗保健','health.png',1,125,1,'health_h.png','health_s.png','health_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (26,'其他花销','misc.png',1,130,1,'misc_h.png','misc_s.png','misc_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (27,'母婴用品','nurturing.png',1,135,1,'nurturing_h.png','nurturing_s.png','nurturing_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100000,'固定支出','',1,2,0,'','','')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100001,'房租物业','real.estate.png',1,5,100000,'real.estate_h.png','real.estate_s.png','real.estate_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100002,'水电煤','housing.png',1,10,100000,'housing_h.png','housing_s.png','housing_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100003,'公交卡','transportation.card.png',1,15,100000,'transportation.card_h.png','transportation.card_s.png','transportation.card_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100004,'充值卡','card.png',1,20,100000,'card_h.png','card_s.png','card_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100005,'培训进修','learning.png',1,25,100000,'learning_h.png','learning_s.png','learning_category.png')"];
        [db execute:@"INSERT INTO category (CategoryId,CategoryName,IconResName,IsActive,DisplayId,ParentId,HIconResName,SIconResName,CIconResName) VALUES (100006,'网络通信','network.png',1,30,100000,'network_h.png','network_s.png','network_category.png')"];
    }
}

+ (void)migrateToCurrentVersion {
    [DbTransitionManager migrateExpenseTable];
    [DbTransitionManager migrateToMonthlyPlan];
    [DbTransitionManager migrateToNewCategories];
}

@end
