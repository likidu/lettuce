//
//  Statistics.h
//  hello
//
//  Created by Rome Lee on 11-7-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistics : NSObject {
    
}

// balance
+ (double)getTotalOfDay:(NSDate*)day;
+ (double)getTotalOfDay:(NSDate *)day excludeFixedExpense:(BOOL)excludeFixed;
+ (double)getTotalOfMonth:(NSDate*)dayOfMonth;
+ (double)getTotalOfMonth:(NSDate *)dayOfMonth excludeFixedExpense:(BOOL)excludeFixed;
+ (NSDictionary*)getTotalBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
+ (NSDictionary*)getTotalBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate excludeFixedExpense:(BOOL)excludeFixed;
+ (double)getBalanceOfDay:(NSDate*)day;
+ (double)getBalanceOfMonth:(NSDate*)dayOfMonth;
+ (double)getSavingOfMonth:(NSDate*)dayOfMonth;
+ (NSDate*)getFirstDayOfUserAction;
+ (NSArray*)getMonthsOfYear:(NSDate*)dayOfYear;
+ (NSArray*)getAvailableYears;

+ (NSDictionary*)getTotalByCategoryfromDate:(NSDate*)startDate toDate:(NSDate*)endDate excludeFixedExpenses:(BOOL)excludeFixed;
+ (NSDictionary*)getTotalOfCategory:(int)categoryId fromMonth:(NSDate*)dayOfStartMonth toMonth:(NSDate*)dayOfEndMonth;

@end
