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
@synthesize displayId;
@synthesize parentId;
@synthesize categoryName;
@synthesize iconName;
@synthesize hilitedIconName;
@synthesize smallIconName;
@synthesize isActive;
@synthesize categoryIconName;

- (void)dealloc{
    [categoryName release];
    [iconName release];
    [hilitedIconName release];
    [super dealloc];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%d, %d, %@, %@, %@", parentId, categoryId, categoryName, iconName, hilitedIconName];
}

@end

CategoryManager* g_catMan = nil;

@implementation CategoryManager

@synthesize categoryCollection;
@synthesize categoryDictionary;
@synthesize topCategoryCollection;
@synthesize needReloadCategory;

- (id)init {
    [super init];
    NSString* path = [[NSBundle mainBundle]pathForResource:@"iconlist" ofType:@"plist"];
    NSArray* iconList = [NSArray arrayWithContentsOfFile:path];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:iconList.count];
    BOOL isHiRes = [[UIScreen mainScreen]scale] == 2.0;
    for (NSString* iconName in iconList) {
        NSString* fileName = iconName;
        if (isHiRes)
            fileName = [iconName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x.png"];
        UIImage* image = [UIImage imageNamed:fileName];
        
        if (isHiRes)
            image = [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:UIImageOrientationUp];
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
    cat.displayId = [[dict objectForKey:@"DisplayId"]intValue];
    cat.parentId = [[dict objectForKey:@"ParentId"]intValue];
    cat.categoryName = [dict objectForKey: @"CategoryName"];
    cat.iconName = [dict objectForKey: @"IconResName"];
    cat.hilitedIconName = [dict objectForKey:@"HIconResName"];
    cat.smallIconName = [dict objectForKey:@"SIconResName"];
    cat.categoryIconName = [dict objectForKey:@"CIconResName"];
    cat.isActive = [[dict objectForKey:@"IsActive"]boolValue];
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

+ (Category *)categoryById:(int)catId {
    NSDictionary* dict = [[CategoryManager instance]categoryDictionary];
    return [dict objectForKey:[NSNumber numberWithInt:catId]];
}

- (void)dealloc {
    [categoryCollection release];
    [categoryDictionary release];
    [topCategoryCollection release];
    [iconDict release];
    [super dealloc];
}

// make sure to call loadCategoryDataFromDatabase: with YES to force update the category data
- (NSArray*)moveCategory:(int)categoryIndex ofCollection:(NSArray *)collection toPosition:(int)newIndex {
    NSMutableArray* newArray = [NSMutableArray arrayWithArray:collection];
    Category* cat = [newArray objectAtIndex:categoryIndex];
    if (newIndex <= categoryIndex) {        
        [newArray insertObject:cat atIndex:newIndex];
        [newArray removeObjectAtIndex:(categoryIndex + 1)];
    }
    else{
        [newArray insertObject:cat atIndex:newIndex + 1];
        [newArray removeObjectAtIndex:categoryIndex];
    }
    // now update the database
    Database* db = [Database instance];
    int displayId = 5;
    for (Category* category in newArray) {
        NSString* sql = [NSString stringWithFormat:@"update category set displayid = %d where categoryid = %d", displayId, category.categoryId];
        [db execute:sql];
        category.displayId = displayId;
        displayId += 5;
    }
    self.needReloadCategory = YES;
    return newArray;
}

+ (NSString *)categoryNameById:(int)catId {
    Category* cat = [CategoryManager categoryById:catId];
    NSString* name = [NSString string];
    if (cat)
        name = cat.categoryName;
    return name;
}

@end
