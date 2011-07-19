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
+ (double)getBalanceOfDay:(NSDate*)day;
+ (double)getBalanceOfMonth:(NSDate*)dayInMonth;
+ (double)getSavingOfMonth:(NSDate*)dayInMonth;

@end
