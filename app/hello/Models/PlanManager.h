//
//  PlanManager.h
//  hello
//
//  Created by Rome Lee on 11-6-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RawPlan : NSObject {
@private
    
}

@property (nonatomic) int planId;
@property (nonatomic) int year;
@property (nonatomic) int month;
@property (nonatomic) double amount;
@property (nonatomic) double workday;
@property (nonatomic) double vacation;

@end

@interface MonthlyPlan : NSObject {
@private

}

@property (nonatomic) int planId;
@property (nonatomic) double income;
@property (nonatomic) double budget;
@property (nonatomic, retain) NSDate* dayOfMonth;

@end

@interface PlanManager : NSObject {
}

+ (void)loadFromDb;

+ (double)getIncomeOfMonth:(NSDate*)dayOfMonth;
+ (double)getBudgetOfMonth:(NSDate*)dayOfMonth;
+ (double)getBudgetOfDay:(NSDate*)day;
+ (void)setIncome:(double)income ofMonth:(NSDate*)dayOfMonth;
+ (void)setBudget:(double)budget ofMonth:(NSDate*)dayOfMonth;
+ (NSDate*)firstDayOfPlan;

@end
