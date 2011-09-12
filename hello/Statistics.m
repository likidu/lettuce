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


@implementation Statistics

+(double)getTotalOfDay:(NSDate *)day {
    
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

+ (double)getBalanceOfDay:(NSDate *)day {
    BudgetManager* budMan = [BudgetManager instance];
    double totalExpense = [Statistics getTotalOfDay:day];
    return [budMan getBudgetOfDay:day] - totalExpense;
}

+ (double)getBalanceOfMonth {
    NSDate* today = normalizeDate([NSDate date]);
    NSDate* firstDay = firstDayOfMonth(today);
    NSDate* lastDay = lastDayOfMonth(today);
    NSArray* days = getDatesBetween(firstDay, lastDay);
    double balance = 0.0;
    for (NSDate* day in days)
        balance += [[BudgetManager instance]getBudgetOfDay:day];
    balance -= [[ExpenseManager instance]loadTotalOfMonth:today];
    if (balance < 0)
        balance = 0.0;
    return balance;
}

+ (double)getSavingOfMonth:(NSDate *)dayInMonth {
    NSDate* firstDay = [ExpenseManager firstDayOfExpense];
    NSDate* today = normalizeDate([NSDate date]);
    if (firstDay == nil)
        return 0.0;
    NSDate* firstMonthDay = firstDayOfMonth(dayInMonth);
    NSDate* lastMonthDay = lastDayOfMonth(dayInMonth);
    firstMonthDay = maxDay(firstDay, firstMonthDay);
    lastMonthDay = minDay(lastMonthDay, today);
    double total = [[ExpenseManager instance]loadTotalOfMonth:dayInMonth];
    NSArray* days = getDatesBetween(firstMonthDay, lastMonthDay);
    double saving = 0.0;
    for (NSDate* day in days)
        saving += [[BudgetManager instance]getBudgetOfDay:day];
    saving -= total;
    if (saving < 0)
        saving = 0.0;
    return saving;
}

@end
