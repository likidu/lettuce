//
//  IncomeManager.h
//  woojuu
//
//  Created by syrett on 13-8-26.
//  Copyright (c) 2013年 JingXi Mill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Income : NSObject
{
    @private
}

@property(nonatomic) int incomeId;
@property(nonatomic) double amount;
@property(nonatomic, retain) NSDate* date;
@property(nonatomic, retain) NSString* notes;

@end

@interface IncomeManager:NSObject

+ (IncomeManager*) instance;

- (NSArray*) loadIncomeOfDay : (NSDate*) date orderBy : (NSString*)fieldName ascending : (BOOL)isAscending;

- (NSArray*) loadMonths;

- (NSArray*) loadIncomeDates;

- (BOOL)addIncome : (Income*) income;
- (BOOL)updateIncome : (Income*) income;
@end