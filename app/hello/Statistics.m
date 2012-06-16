//
//  Statistics.m
//  hello
//
//  Created by Rome Lee on 11-7-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Statistics.h"
#import "Database.h"
#import "Utility.h"
#import "ExpenseManager.h"
#import "BudgetManager.h"
#import "PlanManager.h"


@implementation Statistics

+ (double)getTotalOfDay:(NSDate *)day {
    return [Statistics getTotalOfDay:day excludeFixedExpense:YES];
}

+ (double)getTotalOfDay:(NSDate *)day excludeFixedExpense:(BOOL)excludeFixed {
    NSString* dateStr = formatSqlDate(day);
    NSString* sqlString = [NSString stringWithFormat:@"select total(amount) as totalExpense from expense where date = %@", dateStr];
    if (excludeFixed) {
        sqlString = [NSString stringWithFormat:@"%@ and categoryid < %d", sqlString, FIXED_EXPENSE_CATEGORY_ID_START];
    }
    Database* db = [Database instance];
    NSArray* records = [db execute:sqlString];
    if (records.count < 1)
        return NAN;
    NSDictionary* record = [records objectAtIndex:0];
    if (![record objectForKey:@"totalExpense"])
        return NAN;
    double totalExpense = [[record objectForKey:@"totalExpense"]doubleValue];
    return totalExpense;    
}

+ (double)getTotalOfMonth:(NSDate *)dayOfMonth {
    return [Statistics getTotalOfMonth:dayOfMonth excludeFixedExpense:YES];
}

+ (double)getTotalOfMonth:(NSDate *)dayOfMonth excludeFixedExpense:(BOOL)excludeFixed {
    NSString* start = formatSqlDate(firstDayOfMonth(dayOfMonth)), *end = formatSqlDate(lastDayOfMonth(dayOfMonth));
    NSString* sql = [NSString stringWithFormat:@"select total(amount) as TotalExpense from expense where date >= %@ and date <= %@", start, end];
    if (excludeFixed) {
        sql = [NSString stringWithFormat:@"%@ and categoryid < %d", sql, FIXED_EXPENSE_CATEGORY_ID_START];
    }
    NSArray* data = [[Database instance]execute:sql];
    NSDictionary* record = [data lastObject];
    double total = 0.0;
    if (record) {
        total = [[record objectForKey:@"TotalExpense"]doubleValue];
    }
    return total;    
}

+ (NSDictionary *)getTotalBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [Statistics getTotalBetweenStartDate:startDate endDate:endDate excludeFixedExpense:YES];
}

+ (NSDictionary *)getTotalBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate excludeFixedExpense:(BOOL)excludeFixed {
    NSString* start = formatSqlDate(startDate), *end = formatSqlDate(endDate);
    NSString* sql = [NSString stringWithFormat:@"select total(amount) as TotalExpense, date from expense where date >= %@ and date <= %@", start, end];
    if (excludeFixed) {
        sql = [NSString stringWithFormat: @"%@ and categoryid < %d", sql, FIXED_EXPENSE_CATEGORY_ID_START];
    }
    sql = [NSString stringWithFormat:@"%@ group by date", sql];
    NSArray* data = [[Database instance]execute:sql];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:data.count];
    for (NSDictionary* record in data) {
        NSDate* date = dateFromSqlDate([record objectForKey:@"Date"]);
        NSObject* value = [NSNumber numberWithDouble:[[record objectForKey:@"TotalExpense"]doubleValue]];
        [dict setObject:value forKey:DATESTR(date)];
    }
    return dict;    
}

+ (double)getBalanceOfDay:(NSDate *)day {
    double totalExpense = [Statistics getTotalOfDay:day];
    return [PlanManager getBudgetOfDay:day] - totalExpense;
}

+ (double)getBalanceOfMonth:(NSDate*)dayOfMonth {
    double balance = [PlanManager getBudgetOfMonth:dayOfMonth] - [Statistics getTotalOfMonth:dayOfMonth];
    return balance;
}

+ (double)getSavingOfMonth:(NSDate *)dayOfMonth {
    NSDate* firstDay = [Statistics getFirstDayOfUserAction];
    NSDate* today = normalizeDate([NSDate date]);
    if (firstDay == nil)
        return 0.0;
    NSDate* firstMonthDay = firstDayOfMonth(dayOfMonth);
    NSDate* lastMonthDay = lastDayOfMonth(dayOfMonth);
    firstMonthDay = maxDay(firstDay, firstMonthDay);
    lastMonthDay = minDay(lastMonthDay, today);
    double total = [Statistics getTotalOfMonth:dayOfMonth];
    NSArray* days = getDatesBetween(firstMonthDay, lastMonthDay);
    double saving = 0.0;
    for (NSDate* day in days)
        saving += [[BudgetManager instance]getBudgetOfDay:day];
    saving -= total;
    if (saving < 0)
        saving = 0.0;
    return saving;
}

+ (NSDate *)getFirstDayOfUserAction {
    NSDate* firstDayOfExpense = [ExpenseManager firstDayOfExpense];
    NSDate* firstDayOfPlan = [PlanManager firstDayOfPlan];
    if (firstDayOfExpense && firstDayOfPlan)
        return minDay(firstDayOfExpense, firstDayOfPlan);
    if (firstDayOfExpense)
        return firstDayOfExpense;
    if (firstDayOfPlan)
        return firstDayOfPlan;
    return nil;
}

+ (NSArray*)getMonthsOfYear:(NSDate *)dayOfYear {
    NSDate* firstDay = [Statistics getFirstDayOfUserAction];
    NSDate* today = [NSDate date];
    firstDay = [firstDay laterDate: firstMonthOfYear(today)];
    return getMonthsBetween(firstDay, today);
}

@end
