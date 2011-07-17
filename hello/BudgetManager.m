//
//  BudgetManager.m
//  hello
//
//  Created by Rome Lee on 11-5-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetManager.h"
#import "Database.h"

@implementation Budget

@synthesize date;
@synthesize amount;
@synthesize vacationAmount;
@synthesize budgetId;

- (id)init {
    [super init];
    self.date = [NSDate date];
    self.amount = 0.0;
    self.vacationAmount = 0.0;
    self.budgetId = 0;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"%@ - id: %d, amount: %.2f, vacation amount: %.2f, date: %@", [super description], budgetId, amount, vacationAmount, formatSqlDate(date)];
}

@end

BudgetManager* g_budgetMan = nil;

@implementation BudgetManager


- (id)init {
    [super init];
    budgetList = nil;
    [self loadFromDb];
    return self;
}

+ (BudgetManager *)instance {
    if (!g_budgetMan)
        g_budgetMan = [[BudgetManager alloc]init];
    return g_budgetMan;
}

// callback - this function helps handle records loaded from database
- (void)translateBudget : (NSMutableDictionary*)dict : (id) param {
    NSMutableArray * col = (NSMutableArray*)param;
    if (!col) 
        return;
    Budget* b = [[Budget alloc]init];
    b.date = dateFromSqlDate([dict objectForKey:@"Date"]);
    b.amount = [[dict objectForKey:@"Amount"] doubleValue];
    b.vacationAmount = [[dict objectForKey:@"VacationAmount"] doubleValue];
    b.budgetId = [[dict objectForKey:@"BudgetId"]intValue];
    [col addObject:b];
    [b release];
}

- (void)loadFromDb {
    Database* db = [Database instance];
    NSMutableArray* array = [NSMutableArray array];
    if (![db execute:@"select * from budget order by date desc" :self :@selector(translateBudget::) :array]) {
        [array release];
        return;
    }
    
    if (budgetList)
        [budgetList release];
    
    budgetList = [array retain];
}

- (BOOL)setBudgetOfDay:(NSDate*)day withAmount:(double)amount withVacationAmount:(double)vacationAmount {
    if (amount <= 0.0)
        return NO;
    NSString* dateString = formatSqlDate(day);
    Budget* budget = nil;
    for (Budget* b in budgetList) {
        if ([dateString isEqualToString:formatSqlDate(b.date)]) {
            budget = b;
            break;
        }
    }
    NSString* sqlStr;
    if (budget)
        sqlStr = [NSString stringWithFormat:@"update budget set amount = %f, vacationamount = %f where budgetid = %d", amount, vacationAmount, budget.budgetId];
    else
        sqlStr = [NSString stringWithFormat:@"insert into budget(amount, vacationamount, date) values(%f, %f, %@)", amount, vacationAmount, dateString];
    
    Database* db = [Database instance];
    BOOL ret = [db execute:sqlStr :nil :nil :nil];
    [self loadFromDb];
    
    return ret;
}

- (Budget*)getRawBudgetOfDay:(NSDate*)day {
    Budget* budget = [budgetList objectAtIndex:0];
    for (Budget* b in budgetList) {
        NSTimeInterval span = [day timeIntervalSinceDate:b.date];
        if (span >= 0.0) {
            budget = b;
            break;
        }
    }
    return budget;
}

- (double)getBudgetOfDay:(NSDate *)day {
    Budget* budget = [self getRawBudgetOfDay:day];
    if (isWeekend(day))
        return budget.vacationAmount;

    return budget.amount;
}

- (double)getCurrentBudget {
    Budget* budget = [self getRawBudgetOfDay:[NSDate date]];
    return budget.amount;
}

- (double)getCurrentVacationBudget {
    Budget* budget = [self getRawBudgetOfDay:[NSDate date]];
    return budget.vacationAmount;
}

@end
