//
//  Statistics.h
//  hello
//
//  Created by Rome Lee on 11-7-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Statistics : NSObject {
    
}

// balance
+ (double)getTotalOfDay:(NSDate*)day;
+ (double)getTotalOfMonth:(NSDate*)dayOfMonth;
+ (double)getBalanceOfDay:(NSDate*)day;
+ (double)getBalanceOfMonth:(NSDate*)dayOfMonth;
+ (double)getSavingOfMonth:(NSDate*)dayOfMonth;
+ (NSDate*)getFirstDayOfUserAction;

@end
