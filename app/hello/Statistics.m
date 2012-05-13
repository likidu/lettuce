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
    NSString* dateStr = formatSqlDate(day);
    NSString* sqlString = [NSString stringWithFormat:@"select total(amount) as totalExpense from expense where date = %@", dateStr];
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
    ExpenseManager* expMan = [ExpenseManager instance];
    return [expMan loadTotalOfMonth:dayOfMonth];
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
    double total = [[ExpenseManager instance]loadTotalOfMonth:dayOfMonth];
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
