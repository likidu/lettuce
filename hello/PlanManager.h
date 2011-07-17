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

@interface PlanManager : NSObject {
    NSArray* budgetList;
}

+ (PlanManager*)instance;

- (void)loadFromDb;
- (double)getBudgetOfDay:(NSDate*) day;

@property (nonatomic, readonly) BOOL needInitialize;

@end
