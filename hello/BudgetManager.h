//
//  BudgetManager.h
//  hello
//
//  Created by Rome Lee on 11-5-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Budget : NSObject {
@private
    
}

@property (nonatomic, retain) NSDate* date;
@property (nonatomic) double amount;
@property (nonatomic) double vacationAmount;
@property (nonatomic) int budgetId;

@end

@interface BudgetManager : NSObject {
    NSMutableArray* budgetList;
}

+ (BudgetManager*)instance;

- (void)loadFromDb;
- (BOOL)setBudgetOfDay:(NSDate*)day withAmount:(double)amount withVacationAmount:(double)vacationAmount;
- (double)getBudgetOfDay:(NSDate*)day;
- (double)getCurrentBudget;
- (double)getCurrentVacationBudget;
- (double)getTotalBudgetOfMonth:(NSDate*) dayOfMonth;

- (NSDate*)getFirstDayOfCustomBudget;

@end
