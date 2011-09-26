//
//  ExpenseManager.h
//  hello
//
//  Created by Rome Lee on 11-4-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Expense : NSObject {
@private
    
}

@property (nonatomic)           int             expenseId;
@property (nonatomic)           double          amount;
@property (nonatomic)           int             categoryId;
@property (nonatomic, retain)   NSDate*         date;
@property (nonatomic, retain)   NSString*       notes;
@property (nonatomic, retain)   NSString*       pictureRef;
@property (nonatomic)           BOOL            useLocation;
@property (nonatomic)           double          latitude;
@property (nonatomic)           double          longitude;

@end



@interface ExpenseManager : NSObject {
    NSMutableDictionary* iconCache_;
    UIImage* defaultTagImage_;
}

+ (ExpenseManager*) instance;

- (NSArray*) loadExpensesOfDay : (NSDate*) date orderBy : (NSString*)fieldName ascending : (BOOL)isAscending;

- (NSArray*) loadMonths;

- (NSArray*) loadExpenseDates;

- (double) loadTotalOfDay : (NSDate*) date;
- (NSDictionary*) loadTotalBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;
- (double)loadTotalOfMonth:(NSDate*)dayOfMonth;

- (BOOL) addExpense : (Expense*) expense;
- (BOOL)updateExpense:(Expense*)expense;

- (double)getBalanceOfDay:(NSDate*)day;
- (NSDictionary*)getBalanceBetweenStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

- (BOOL)deleteExpenseById:(NSInteger)expenseId;
- (Expense*)getExpenseById:(NSInteger)expenseId;

/*
- (BOOL)saveImageNote:(UIImage*)image withExpenseId:(int)expenseId;

- (BOOL)checkImageNoteByExpenseId:(int)expenseId;

- (UIImage*)getImageNoteIconByExpenseId:(int)expenseId;
 */

#pragma mark - image note
- (NSString*)saveImageNote:(UIImage*)image;
- (UIImage*)loadImageNote:(NSString*)fileName;
- (void)deleteImageNote:(NSString*)fileName;

- (int)getLastInsertedExpensedId;

- (UIImage*)getDefaultTagImage;

- (void)releaseCache;

- (NSArray*)getAvailableDatesBetween:(NSDate*)startDate endDate:(NSDate*)endDate;

- (NSArray*)getExpensesBetween:(NSDate*)startDate endDate:(NSDate*)endDate orderBy:(NSString*)fieldName assending:(BOOL)assending;

+ (NSDictionary*)groupExpensesByDate:(NSArray*)expenses;

+ (NSDate*)firstDayOfExpense;
+ (NSDate*)lastDayOfExpense;

@end
