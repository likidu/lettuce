//
//  PlanManager.m
//  hello
//
//  Created by Rome Lee on 11-6-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlanManager.h"
#import "Database.h"

@implementation RawPlan

- (id)init {
    self.planId = 0;
    self.amount = 0;
    self.year = 0;
    self.month = 0;
    self.workday = 0.0;
    self.vacation = 0.0;
    return self;
}

@synthesize planId;
@synthesize amount;
@synthesize year;
@synthesize month;
@synthesize workday;
@synthesize vacation;

@end

PlanManager* g_instance = nil;

@implementation PlanManager

+ (PlanManager*)instance {
    if (g_instance == nil)
        g_instance = [[PlanManager alloc]init];
    return g_instance;
}

- (id)init {
    [super init];
    budgetList = nil;
    return self;
}

- (void)dealloc {
    [budgetList release];
    [super dealloc];
}

// callback - this function helps handle records loaded from database
- (void)translateBudget : (NSMutableDictionary*)dict : (id) param {
    NSMutableArray * col = (NSMutableArray*)param;
    if (!col) 
        return;
    RawPlan* plan = [[RawPlan alloc]init];
    plan.planId = [[dict objectForKey:@"Planid"]intValue];
    plan.amount = [[dict objectForKey:@"Amount"]doubleValue];
    plan.year = [[dict objectForKey:@"Year"]intValue];
    plan.month = [[dict objectForKey:@"Month"]intValue];
    plan.workday = [[dict objectForKey:@"Workday"]doubleValue];
    plan.vacation = [[dict objectForKey:@"Vacation"]doubleValue];
    [col addObject:plan];
    [plan release];
}

- (void)loadFromDb {
    Database* db = [Database instance];
    NSMutableArray* array = [[NSMutableArray alloc]init];
    if (![db execute:@"select * from plan orderby year desc, month desc" :self :@selector(translateBudget::) :array]) {
        [array release];
        return;
    }
    if (budgetList)
        [budgetList release];
    budgetList = [[NSArray alloc]initWithArray:array];
}

- (BOOL)needInitialize {
    return budgetList == nil;
}

- (BOOL)isLeapYear:(int)year {
    if (year % 4)
        return NO;
    if (year % 100)
        return YES;
    if (year % 400)
        return NO;
    return YES;
}

- (int)getDaysOfMonth:(int)month ofYear:(int)year {
    switch (month) {
        case 2:
            if ([self isLeapYear:year])
                return 29;
            else
                return 28;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
            break;
            
        default:
            return 31;
            break;
    }
}

- (int)getDayAmountOfMonth:(NSDate*)dayOfMonth {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:dayOfMonth];
    return [self getDaysOfMonth:components.month ofYear:components.year];
}

- (void)getDaysOfMonth:(NSDate*)dayOfMonth workingDays:(int*)workingDays vacationDays:(int*)vacationDays {
    *workingDays = 0;
    *vacationDays = 0;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSWeekdayCalendarUnit fromDate:dayOfMonth];
    int days = [self getDayAmountOfMonth:dayOfMonth];
    for (int i = 0; i < days; i++) {
        components.day = i;
        if (components.weekday == 1 || components.weekday == 7)
            ++(*vacationDays);
        else
            ++(*workingDays);
    }
}

- (NSArray*)getDaysOfMonth:(NSDate*)dayOfMonth {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSWeekdayCalendarUnit fromDate:dayOfMonth];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity: [self getDayAmountOfMonth:dayOfMonth]];
    for (int i = 0; i < array.count; i++) {
        components.day = i;
        int dayCode = 0;
        if (components.weekday == 1 || components.weekday == 7)
            dayCode = 1;
        [array insertObject:[NSNumber numberWithInt:dayCode ] atIndex:i];
    }
    return [NSArray arrayWithArray:array];
}

- (void)translateDailyExpense : (NSMutableDictionary*)dict : (id) param {
    NSMutableDictionary * col = (NSMutableDictionary*)param;
    if (!col) 
        return;
    [col setObject:[NSNumber numberWithInt: [[dict objectForKey:@"Amount"]doubleValue]] forKey:[NSNumber numberWithInt:[[dict objectForKey:@"Day"]intValue]]];
}

- (NSArray*)getDailyExpenseOfMonth:(NSDate*)dayOfMonth {
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    Database* db = [Database instance];
    NSString* monthStr = formatSqlYearMonth(dayOfMonth);
    NSString* sqlStr = [NSString stringWithFormat:@"select sum(amount) as Total, strftime('%d', date) as Day from expense where strftime('%Y-%m', date) = '%@' group by strftime('%Y-%m-%d', date) order by date", monthStr];
    if (![db execute:sqlStr :self :@selector(translateDailyExpense::) :result]) {
        [result release];
        return nil;
    }
    int days = [self getDayAmountOfMonth:dayOfMonth];
    NSNumber* defaultExpense = [NSNumber numberWithDouble: 0.0];
    NSMutableArray* keys = [[NSMutableArray alloc]initWithCapacity:days];
    for (int i = 0; i < days; i++)
        [keys insertObject:[NSNumber numberWithInt:i+1] atIndex:i];
    NSArray* ret = [result objectsForKeys:keys notFoundMarker: defaultExpense];
    [result release];
    return ret;
}

- (void)getBudget:(double)totalBudget ofRange:(NSArray*)days startDay:(int)startIndex usingRatio:(double)ratio workingDay:(double*)workingDay vacationDay:(double*)vacationDay {
    int wDayCount = 0, vDayCount = 0;
    for (int i = startIndex; i < days.count; i++) {
        if ([[days objectAtIndex:i]intValue])
            ++vDayCount;
        else
            ++wDayCount;
    }
    *workingDay = totalBudget / (wDayCount * ratio + vDayCount);
    *vacationDay = ratio * (*workingDay);
}

- (double)getBudget:(double)totalBudget ofDay:(int)dayIndex withRange:(NSArray*)days withExpenses:(NSArray*)expenses withRitio:(double)ratio {
    
    return 0.0;
}

- (double)getBudgetOfDay:(NSDate *)day {
    if (self.needInitialize)
        return 0.0;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSWeekdayCalendarUnit fromDate:day];
    int year = components.year;
    int month = components.month;
    RawPlan* effectivePlan = nil;
    for (RawPlan* plan in budgetList) {
        if (year >= plan.year && month >= plan.month) {
            effectivePlan = plan;
            break;
        }
    }
    int workingDays = 0, vacationDays = 0;
    [self getDaysOfMonth:day workingDays:&workingDays vacationDays:&vacationDays];
    NSArray* days = [self getDaysOfMonth:day];
    NSArray* expenses = [self getDailyExpenseOfMonth:day];
    int dayIndex = components.day - 1;
    double budget = [self getBudget:effectivePlan.amount ofDay:dayIndex withRange:days withExpenses:expenses withRitio:1.5];
    return budget;
}

@end
