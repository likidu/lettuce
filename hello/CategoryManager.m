//
//  CategoryManager.m
//  hello
//
//  Created by Rome Lee on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryManager.h"
#import "Database.h"

@implementation Category

@synthesize categoryId;
@synthesize parentId;
@synthesize categoryName;
@synthesize iconName;
@synthesize hilitedIconName;

- (void)dealloc{
    [super dealloc];
    [categoryName release];
    [iconName release];
    [hilitedIconName release];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%d, %d, %s, %s, %s", parentId, categoryId, categoryName, iconName, hilitedIconName];
}

@end

CategoryManager* g_catMan = nil;

@implementation CategoryManager

@synthesize categoryCollection;
@synthesize categoryDictionary;
@synthesize topCategoryCollection;

- (id)init {
    [super init];
    NSString* path = [[NSBundle mainBundle]pathForResource:@"iconlist" ofType:@"plist"];
    NSArray* iconList = [NSArray arrayWithContentsOfFile:path];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:iconList.count];
    for (NSString* iconName in iconList) {
        UIImage* image = [UIImage imageNamed:iconName];
        image = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];
        [dict setObject:image forKey:iconName];
    }
    iconDict = [dict retain];
    return self;
}

+ (CategoryManager*)instance
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        g_catMan = [[CategoryManager alloc]init];
        initialized = YES;
    }
    return g_catMan;
}

// callback - this function helps handle records loaded from database
- (void)translateCategory : (NSMutableDictionary*)dict : (id) param {
    NSMutableArray * col = (NSMutableArray*)param;
    if (!col) 
        return;
    Category *cat = [[Category alloc]init];
    cat.categoryId = [[dict objectForKey: @"CategoryId"]intValue];
    cat.parentId = [[dict objectForKey:@"ParentId"]intValue];
    cat.categoryName = [dict objectForKey: @"CategoryName"];
    cat.iconName = [dict objectForKey: @"IconResName"];
    cat.hilitedIconName = [dict objectForKey:@"HIconResName"];
    [col addObject:cat];
    [cat release];
}

- (BOOL)loadCategoryDataFromDatabase:(BOOL)forceReload {
    if (categoryCollection != nil && categoryDictionary != nil && forceReload == NO)
        return YES;
    
    self.categoryCollection = [NSMutableArray array];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.categoryDictionary = dict;
    
    Database* db = [Database instance];
    if (![db execute: @"select * from category where parentid <> 0 order by parentid, displayid" :self :@selector(translateCategory::) :self.categoryCollection]) {
        self.categoryCollection = nil;
        self.categoryDictionary = nil;
        return NO;
    }
    
    for (int i = 0; i < categoryCollection.count; i++) {
        Category* cat = [categoryCollection objectAtIndex:i];
        [dict setObject:cat forKey: [NSNumber numberWithInt:cat.categoryId]];
    }
    
    self.topCategoryCollection = [NSMutableArray array];
    if (![db execute:@"select * from category where parentid = 0 order by displayid" :self :@selector(translateCategory::) :self.topCategoryCollection]) {
        self.categoryCollection = nil;
        self.categoryDictionary = nil;
        self.topCategoryCollection = nil;
        return NO;
    }
    
    return YES;
}

- (UIImage*)iconNamed:(NSString *)iconName {
    return [iconDict objectForKey:iconName];
}

- (NSArray *)getSubCategoriesWithCategoryId:(int)catId {
    NSMutableArray* ret = [NSMutableArray array];
    for (Category* cat in self.categoryCollection) {
        if (cat.parentId == catId) {
            [ret addObject:cat];
        }
    }
    return ret;
}

- (void)dealloc {
    [super dealloc];
    [categoryCollection release];
    [categoryDictionary release];
    [topCategoryCollection release];
    [iconDict release];
}

@end
