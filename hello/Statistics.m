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

+ (double)getBalanceOfDay:(NSDate *)day {
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
    BudgetManager* budMan = [BudgetManager instance];
    return [budMan getBudgetOfDay:day] - totalExpense;
}

+ (double)getBalanceOfMonth:(NSDate *)dayInMonth {
    NSDateComponents* components = [[NSCalendar currentCalendar]components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:dayInMonth];
    int days = getDayAmountOfMonth(dayInMonth);
    int day = components.day;
    if (day > days)
        return NAN;
    double balance = [self getBalanceOfDay: dayInMonth];
    BudgetManager* budMan = [BudgetManager instance];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    for (int i = day + 1; i <= days; i++) {
        [components setDay:i];
        balance += [budMan getBudgetOfDay: [calendar dateFromComponents:components]];
    }
    return balance;
}

+ (double)getSavingOfMonth:(NSDate *)dayInMonth {
    NSDateComponents* components = [[NSCalendar currentCalendar]components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:dayInMonth];
    int day = components.day;
    double saving = 0.0;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    for (int i = 1; i <= day; i++) {
        [components setDay:i];
        saving += [self getBalanceOfDay:[calendar dateFromComponents:components]];
    }
    return saving;
}

/*
 NSString* yearMonthStr = formatSqlYearMonth(dayInMonth);
 NSString* sqlString = [NSString stringWithFormat:@"select total(amount) as totalExpense from expense where strftime('%%Y-%%m', date) = '%@'", yearMonthStr];
 Database* db = [Database instance];
 NSArray* records = [db execute:sqlString];
 if (records.count < 1)
 return NAN;
 NSDictionary* record = [records objectAtIndex:0];
 if (![record objectForKey:@"totalExpense"])
 return NAN;
 double totalExpense = [[record objectForKey:@"totalExpense"]doubleValue];
 
 return totalExpense;
 */

@end
