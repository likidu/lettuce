//
//  CategoryManager.h
//  hello
//
//  Created by Rome Lee on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject {
    
}
@property (nonatomic) int categoryId;
@property (nonatomic) int displayId;
@property (nonatomic) int parentId;
@property (nonatomic) BOOL isActive;
@property (nonatomic, retain) NSString *categoryName;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic, retain) NSString *hilitedIconName;
@property (nonatomic, retain) NSString *smallIconName;

@end


@interface CategoryManager : NSObject {
    NSDictionary* iconDict;
}

+ (CategoryManager*)instance;
+ (Category*)categoryById:(int)catId;
+ (NSString*)categoryNameById:(int)catId;

@property (nonatomic, retain) NSArray *categoryCollection;
@property (nonatomic, retain) NSDictionary* categoryDictionary;
@property (nonatomic, retain) NSArray *topCategoryCollection;

- (BOOL)loadCategoryDataFromDatabase : (BOOL)forceReload;
- (UIImage*)iconNamed:(NSString*)iconName;
- (NSArray*)getSubCategoriesWithCategoryId:(int)catId;

// modify the order of sub category
- (NSArray*)moveCategory:(int)categoryIndex ofCollection:(NSArray*)collection toPosition:(int)newIndex;

@end
