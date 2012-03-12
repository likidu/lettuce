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

@implementation MonthlyPlan

- (id)init {
    self = [super init];
    if (self) {
        self.planId = 0;
        self.income = 0.0;
        self.budget = 0.0;
        self.dayOfMonth = nil;
    }
    return self;
}

@synthesize planId;
@synthesize income;
@synthesize budget;
@synthesize dayOfMonth;

@end

NSArray* g_planList = nil;

@implementation PlanManager

+ (void)loadFromDb {
    CLEAN_RELEASE(g_planList);
    Database* db = [Database instance];
    NSArray* records = [db execute:@"SELECT * FROM monthly_plan ORDER BY Date"];
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:records.count];
    for (NSDictionary* rec in records) {
        MonthlyPlan* plan = [[MonthlyPlan alloc]init];
        plan.planId = [[rec objectForKey:@"PlanId"]intValue];
        plan.income = [[rec objectForKey:@"Income"]doubleValue];
        plan.budget = [[rec objectForKey:@"Budget"]doubleValue];
        plan.dayOfMonth = normalizeDate(dateFromSqlDate([rec objectForKey:@"Date"]));
        [list addObject:plan]; 
    }
    g_planList = list;
}
/*
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
 
*/

+ (double)getBudgetOfDay:(NSDate *)day {
    double budget = [PlanManager getBudgetOfMonth:day];
    double budgetOfDay = budget / (double)getDayAmountOfMonth(day);
    return budgetOfDay;
}

+ (MonthlyPlan*)getPlanOfMonth:(NSDate*)dayOfMonth {
    if (!g_planList || g_planList.count == 0)
        return nil;
    MonthlyPlan* closestPlan = [g_planList objectAtIndex:0];
    for (MonthlyPlan* plan in g_planList) {
        if (compareMonth(plan.dayOfMonth, closestPlan.dayOfMonth) > 0)
            closestPlan = plan;
    }
    return closestPlan;
}

+ (double)getBudgetOfMonth:(NSDate *)dayOfMonth {
    MonthlyPlan* plan = [PlanManager getPlanOfMonth:dayOfMonth];
    if (plan)
        return plan.budget;
    return 0.0;
}

+ (double)getIncomeOfMonth:(NSDate *)dayOfMonth {
    MonthlyPlan* plan = [PlanManager getPlanOfMonth:dayOfMonth];
    if (plan)
        return plan.income;
    return 0.0;
}

+ (void)setBudget:(double)budget ofMonth:(NSDate *)dayOfMonth {
    MonthlyPlan* plan = [PlanManager getPlanOfMonth:dayOfMonth];
    NSString* sqlStr = nil;
    if (plan && isSameMonth(plan.dayOfMonth, dayOfMonth))
        sqlStr = [NSString stringWithFormat:@"UPDATE monthly_plan SET Budget = %f, Date = %@ WHERE PlanId = %d", budget, formatSqlDate(dayOfMonth), plan.planId];
    else
        sqlStr = [NSString stringWithFormat:@"INSERT INTO monthly_plan(Budget, Date) VALUES(%f, %@)", budget, formatSqlDate(dayOfMonth)];
    Database* db = [Database instance];
    [db execute:sqlStr];
    
    [PlanManager loadFromDb];
}

+ (void)setIncome:(double)income ofMonth:(NSDate *)dayOfMonth {
    MonthlyPlan* plan = [PlanManager getPlanOfMonth:dayOfMonth];
    NSString* sqlStr = nil;
    if (plan && isSameMonth(plan.dayOfMonth, dayOfMonth))
        sqlStr = [NSString stringWithFormat:@"UPDATE monthly_plan SET Income = %f, Date = %@ WHERE PlanId = %d", income, formatSqlDate(dayOfMonth), plan.planId];
    else
        sqlStr = [NSString stringWithFormat:@"INSERT INTO monthly_plan(Income, Date) VALUES(%f, %@)", income, formatSqlDate(dayOfMonth)];
    Database* db = [Database instance];
    [db execute:sqlStr];
    
    [PlanManager loadFromDb];
}

+ (NSDate*)firstDayOfPlan {
    if (!g_planList || g_planList.count == 0)
        return nil;
    MonthlyPlan* plan = (MonthlyPlan*)[g_planList objectAtIndex:0];
    return plan.dayOfMonth;
}

/*

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
 
*/

@end
