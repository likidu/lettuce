//
//  IncomeManager.m
//  woojuu
//
//  Created by syrett on 13-8-26.
//  Copyright (c) 2013年 JingXi Mill. All rights reserved.
//

#import "Database.h"
#import "Utility.h"
#import "IncomeManager.h"

@implementation Income

@synthesize incomeId;
@synthesize amount;
@synthesize date;
@synthesize notes;

- (Income*) init
{   
    date = nil;
    notes = nil;
    return self;
}
@end

static IncomeManager* g_instance = nil;

@implementation IncomeManager

+ (IncomeManager*)instance
{
    if (g_instance == nil) {
        g_instance = [[IncomeManager alloc] init];
    }
    return g_instance;
}

- (id)init 
{
    return [super init];
}

- (BOOL)addIncome:(Income *)income
{
    NSString* amountStr = [NSString stringWithFormat:@"%f", income.amount];
    NSString* dateStr = formatSqlDate(income.date);
    NSString* notesStr = formatSqlString(income.notes);

    NSString* formatStr = @"insert into income (amount, date, notes) values (%@, %@, %@)";
    
    NSString* sqlStr = [NSString stringWithFormat:formatStr, amountStr, dateStr, notesStr];
    
    Database* db = [Database instance];
    return [db execute:sqlStr :nil :nil :nil];
}

@end
