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
    kSavingDate = 1,
    kSavingExpense = 2,
    kSavingBalance = 3,
    kSavingBudget = 4,
};

@protocol DateRangeResponder <NSObject>

@required
- (void)setStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
- (void)reload;
- (BOOL)canEdit;

@optional
@property(nonatomic, assign) BOOL editing;

@end