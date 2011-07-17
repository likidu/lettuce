//
//  ExpenseManager.m
//  hello
//
//  Created by Rome Lee on 11-4-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "ExpenseManager.h"
#import "BudgetManager.h"

@implementation Expense

@synthesize expenseId;
@synthesize categoryId;
@synthesize amount;
@synthesize date;
@synthesize notes;
@synthesize pictureRef;

- (Expense*) init {
    date = nil;
    notes = nil;
    pictureRef = nil;
    return self;
}

@end

static ExpenseManager* g_instance = nil;

@implementation ExpenseManager

+ (ExpenseManager*)instance {
    if (g_instance == nil) {
        g_instance = [[ExpenseManager alloc]init];
    }
    return g_instance;
}

- (id)init {
    iconCache_ = [[NSMutableDictionary alloc]init];
    defaultTagImage_ = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tag" ofType:@"png"]];
    return [super init];
}

- (void)dealloc {
    CLEAN_RELEASE(iconCache_);
    [defaultTagImage_ release];
    [super dealloc];
}

// callback - this function helps handle records loaded from database
- (void)translateExpense : (NSMutableDictionary*)dict : (id)param {
    Expense* expense = [[Expense alloc]init];
    expense.expenseId = [[dict objectForKey:@"ExpenseId"] intValue];
    expense.categoryId = [[dict objectForKey:@"CategoryId"] intValue];
    expense.amount = [[dict objectForKey:@"Amount"] doubleValue];
    expense.notes  = [dict objectForKey:@"Notes"];
    expense.pictureRef = [dict objectForKey:@"PictureRef"];

    NSMutableArray* array = (NSMutableArray*)param;
    if (array == nil)
        return;
    [array addObject:expense];
    [expense release];
}

- (NSArray *)loadExpensesOfDay:(NSDate *)date orderBy:(NSString *)fieldName ascending:(BOOL)isAscending {
    NSString* dateStr = formatSqlDate(date);
    NSString* optionStr = isAscending ? @"" : @"DESC";
    NSString* sqlText = [NSString stringWithFormat:@"select * from expense where Date = %@ order by %@ %@", dateStr, fieldName, optionStr];
    
    NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
    Database* db = [Database instance];
    [db execute:sqlText :self :@selector(translateExpense::) :array];
    return array;
}

- (void)translateExpenseDate : (NSMutableDictionary*)dict : (id)param {
    NSString* dateStr = [dict objectForKey:@"Date"];
    NSDate* date = dateFromSqlDate(dateStr);
    NSMutableArray* array = (NSMutableArray*)param;
    [array addObject:date];
}

- (NSArray*)loadExpenseDates {
    NSString* sqlText = @"select distinct date from expense order by date desc";
    NSMutableArray* array = [NSMutableArray array];
    Database* db = [Database instance];
    [db execute:sqlText :self :@selector(translateExpenseDate::) :array];
    return array;
}

- (void)translateTotalOfDay : (NSMutableDictionary*)dict : (id)param {
    NSMutableArray* array = (NSMutableArray*)param;
    [array addObject:[NSNumber numberWithDouble:[[dict objectForKey:@"TotalExpense"] doubleValue]]];
}

- (double)loadTotalOfDay:(NSDate *)date {
    NSString* dateStr = formatSqlDate(date);
    NSString* sqlStr = [NSString stringWithFormat:@"select total(amount) as TotalExpense from expense where date = %@", dateStr];
    Database* db = [Database instance];
    NSMutableArray* array = [NSMutableArray array];
    [db execute:sqlStr :self :@selector(translateTotalOfDay::) :array];
    return [[array objectAtIndex:0]doubleValue];
}

- (BOOL)addExpense:(Expense *)expense {
    NSString* categoryIdStr = [NSString stringWithFormat:@"%d", expense.categoryId];
    NSString* amountStr = [NSString stringWithFormat:@"%f", expense.amount];
    NSString* dateStr = formatSqlDate(expense.date);
    NSString* notesStr = formatSqlString(expense.notes);
    NSString* pictureRefStr = formatSqlString(expense.pictureRef);
    
    NSString* formatStr = @"insert into expense (categoryid, amount, date, notes, pictureref) values (%@, %@, %@, %@, %@)";
    NSString* sqlStr = [NSString stringWithFormat:formatStr, categoryIdStr, amountStr, dateStr, notesStr, pictureRefStr];
    
    Database* db = [Database instance];
    return [db execute:sqlStr :nil :nil :nil];
}

- (double)getBalanceOfDay:(NSDate *)day {
    BudgetManager* budMan = [BudgetManager instance];
    return [budMan getBudgetOfDay:day] - [self loadTotalOfDay:day];
}

- (BOOL)deleteExpenseById:(NSInteger)expenseId {
    NSString * sqlStr = [NSString stringWithFormat: @"delete from expense where expenseid = %d", expenseId];
    Database* db = [Database instance];
    return [db execute:sqlStr :nil :nil :nil];
}

- (BOOL)saveImageNote:(UIImage *)image withExpenseId:(int)expenseId {
    NSString* iconFileName = [NSString stringWithFormat:@"%d_icon.jpg", expenseId];
    NSString* originalFileName = [NSString stringWithFormat:@"%d.jpg", expenseId];
    NSString* imageNotePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageNotes"];
    iconFileName = [imageNotePath stringByAppendingPathComponent: iconFileName];
    originalFileName = [imageNotePath stringByAppendingPathComponent: originalFileName];
    NSFileManager* fileMan = [NSFileManager defaultManager];
    if ([fileMan fileExistsAtPath:iconFileName isDirectory:nil])
        [fileMan removeItemAtPath:iconFileName error:nil];
    if ([fileMan fileExistsAtPath:originalFileName isDirectory:nil])
        [fileMan removeItemAtPath:originalFileName error:nil];
    if (![UIImageJPEGRepresentation(image, 0.8) writeToFile:originalFileName atomically:YES])
        return NO;
    
    // save the thumbnail 64 * 64 image
    UIGraphicsBeginImageContext(CGSizeMake(64, 64));
    [image drawInRect:CGRectMake(0, 0, 64, 64)];
    UIImage* icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (!iconCache_)
        iconCache_ = [[NSMutableDictionary alloc]init];
    if (icon)
        [iconCache_ setObject:icon forKey: [NSNumber numberWithInt: expenseId]];
    
    return [UIImageJPEGRepresentation(icon, 1.0) writeToFile:iconFileName atomically:YES];
}

- (UIImage*)getImageNoteIconByExpenseId:(int)expenseId {
    UIImage* icon = [iconCache_ objectForKey: [NSNumber numberWithInt: expenseId]];
    if (icon)
        return icon;
    
    if (!iconCache_)
        iconCache_ = [[NSMutableDictionary alloc]init];
    
    NSString* iconFileName = [NSString stringWithFormat:@"%d_icon.jpg", expenseId];
    NSString* imageNotePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageNotes"];
    iconFileName = [imageNotePath stringByAppendingPathComponent: iconFileName];
    icon = [UIImage imageWithContentsOfFile:iconFileName];
    
    if (icon)
        [iconCache_ setObject:icon forKey: [NSNumber numberWithInt: expenseId]];
    
    return icon;
}

- (void)translateIntId : (NSMutableDictionary*)dict : (id)param {
    int* data = (int*)param;
    *data = [[dict objectForKey:@"id"] intValue];
}

- (int)getLastInsertedExpensedId {
    NSString* sqlStr = @"select max(expenseid) as id from expense";
    int data = 0;
    [[Database instance]execute:sqlStr :self :@selector(translateIntId::) : (id)&data];
    return data;
}

- (void)releaseCache {
    CLEAN_RELEASE(iconCache_);
}

- (UIImage*)getDefaultTagImage {
    return defaultTagImage_;
}

@end
