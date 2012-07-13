//
//  TableViewProtocol.h
//  woojuu
//
//  Created by Rome Lee on 11-8-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CellSubViewTags {
    kHeaderText = 1,
    kHeaderIcon = 2,
    kFooterStamp = 1,
    kFooterText = 2,
    kFooterAmount = 3,
    kCellCategoryIcon = 1,
    kCellCategoryText = 2,
    kCellAmount = 3,
    kCellPhotoIcon = 4,
    kCellDate = 5,
    kCellAmount2 = 6,
    kCellAmount3 = 7,
    kCellNumber = 8,
    kSavingDate = 1,
    kSavingExpense = 2,
    kSavingBalance = 3,
    kSavingBudget = 4,
};

enum TableIds {
    kExpense = 0,
    kSaving = 1,
    kByAmount = 2,
    kByCategory = 3,
    kByLocation = 4
};


@protocol TableUpdateDelegate <NSObject>

@optional
- (void)navigateTo:(int)tableId withData:(NSObject*)data;
- (void)dataChanged;

@end

@protocol DateRangeResponder <NSObject>

@required
- (void)setStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
- (void)reload;
- (BOOL)canEdit;

@optional
@property(nonatomic, assign) BOOL editing;
@property(nonatomic, assign) id<TableUpdateDelegate> tableUpdateDelegate;
- (void)navigateToData:(NSObject*)data;

@end

#define SET_PROP_IF_EXISTS_KEY(prop, dict, key, type) \
    if ([dict objectForKey: key]) \
        (prop) = (type*)[dict objectForKey: (key)];

@protocol ViewOptionResponder <NSObject>

@required
- (void)setViewOptions:(NSDictionary*)options;
- (void)refresh;

@end

@protocol ReportViewDelegate <NSObject>

@optional
- (void)pickedDate:(NSDate*)day;
- (void)pickedCategory:(int)categoryId;

@end
