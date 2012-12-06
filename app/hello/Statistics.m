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
    firstDay = [firstDay laterDate: firstMonthOfYear(dayOfYear)];
    NSDate* today = [NSDate date];
    NSDate* lastDay = [today earlierDate:lastMonthOfYear(dayOfYear)];
    return getMonthsBetween(firstDay, lastDay, YES);
}

+ (NSArray *)getAvailableYears{
    NSDate* firstDay = [Statistics getFirstDayOfUserAction];
    NSDate* today = [NSDate date];
    NSMutableArray* years = [NSMutableArray array];
    NSDateComponents* curComponents = getDateComponentsWithoutTime(firstDay);
    NSDateComponents* endComponents = getDateComponentsWithoutTime(today);
    NSCalendar* calendar = [NSCalendar currentCalendar];
    do {
        [years addObject:[calendar dateFromComponents:curComponents]];
        curComponents.year++;
    } while (curComponents.year <= endComponents.year);
    return years;
}

+ (NSDictionary*)getTotalByCategoryfromDate:(NSDate *)startDate toDate:(NSDate *)endDate excludeFixedExpenses:(BOOL)excludeFixed {
    NSString* start = formatSqlDate(startDate), *end = formatSqlDate(endDate);
    NSString* sql = [NSString stringWithFormat: @"select categoryid, total(amount) as TotalExpense, count(categoryid) as TotalNumber from expense where date >= %@ and date <= %@", start, end];
    if (excludeFixed) {
        sql = [NSString stringWithFormat:@"%@ and categoryid < %d", sql, FIXED_EXPENSE_CATEGORY_ID_START];
    }
    sql = [NSString stringWithFormat:@"%@ group by categoryid order by case when categoryid < %d then 0 else 1 end, TotalExpense DESC", sql, FIXED_EXPENSE_CATEGORY_ID_START];
    Database* db = [Database instance];
    NSArray* records = [db execute:sql];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    NSMutableArray* categories = [NSMutableArray arrayWithCapacity:records.count];
    NSMutableArray* numbers = [NSMutableArray arrayWithCapacity:records.count];
    NSMutableArray* amounts = [NSMutableArray arrayWithCapacity:records.count];
    
    for (NSDictionary* rec in records) {
        int catId = [[rec valueForKey:@"CategoryId"]intValue];
        int number = [[rec valueForKey:@"TotalNumber"]intValue];
        double amount = [[rec valueForKey:@"TotalExpense"]doubleValue];
        [categories addObject:[NSNumber numberWithInt:catId]];
        [numbers addObject:[NSNumber numberWithInt:number]];
        [amounts addObject:[NSNumber numberWithDouble:amount]];
    }
    [dict setValue:categories forKey:@"categories"];
    [dict setValue:numbers forKey:@"numbers"];
    [dict setValue:amounts forKey:@"amounts"];
    return dict;
}

+ (NSDictionary *)getTotalOfCategory:(int)categoryId fromMonth:(NSDate *)dayOfStartMonth toMonth:(NSDate *)dayOfEndMonth {
    dayOfStartMonth = firstDayOfMonth(dayOfStartMonth);
    dayOfEndMonth = lastDayOfMonth(dayOfEndMonth);
    NSString* start = formatSqlDate(dayOfStartMonth), *end = formatSqlDate(dayOfEndMonth);
    NSString* sql = [NSString stringWithFormat: @"select sum(amount) as TotalExpense, count(amount) as TotalNumber, Date from expense where categoryId = %d and date >= %@ and date <= %@ group by strftime('%%m', Date) order by strftime('%%m', Date) desc", categoryId, start, end];
    Database* db = [Database instance];
    NSArray* records = [db execute:sql];
    NSMutableArray* months = [NSMutableArray arrayWithCapacity:records.count];
    NSMutableArray* amounts = [NSMutableArray arrayWithCapacity:records.count];
    NSMutableArray* numbers = [NSMutableArray arrayWithCapacity:records.count];
    for (NSDictionary* record in records) {
        [months addObject:normalizeDate(dateFromSqlDate([record objectForKey: @"Date"]))];
        [amounts addObject:[NSNumber numberWithDouble:[[record objectForKey:@"TotalExpense"]doubleValue]]];
        [numbers addObject:[NSNumber numberWithInt:[[record objectForKey:@"TotalNumber"]intValue]]];
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:3];
    [dict setObject:months forKey:@"months"];
    [dict setObject:numbers forKey:@"numbers"];
    [dict setObject:amounts forKey:@"amounts"];
    return dict;
}

+ (NSArray *)getExpensesOfCategory:(int)categoryId fromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    return [[ExpenseManager instance]getExpensesOfCategory:categoryId fromDate:startDate toDate:endDate];
}

@end
