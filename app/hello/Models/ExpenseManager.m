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
#import "Utility.h"

@implementation Expense

@synthesize expenseId;
@synthesize categoryId;
@synthesize amount;
@synthesize date;
@synthesize notes;
@synthesize pictureRef;
@synthesize useLocation;
@synthesize latitude;
@synthesize longitude;

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
    CLEAN_RELEASE(defaultTagImage_);
    [super dealloc];
}

// callback - this function helps handle records loaded from database
- (void)translateExpense : (NSMutableDictionary*)dict : (id)param {
    Expense* expense = [[[Expense alloc]init]autorelease];
    expense.expenseId = [[dict objectForKey:@"ExpenseId"] intValue];
    expense.categoryId = [[dict objectForKey:@"CategoryId"] intValue];
    expense.amount = [[dict objectForKey:@"Amount"] doubleValue];
    expense.notes  = [dict objectForKey:@"Notes"];
    expense.pictureRef = [dict objectForKey:@"PictureRef"];
    expense.date = normalizeDate(dateFromSqlDate([dict objectForKey:@"Date"]));
    expense.useLocation = [[dict objectForKey:@"UseLocation"]boolValue];
    expense.latitude = [[dict objectForKey:@"Latitude"]doubleValue];
    expense.longitude = [[dict objectForKey:@"Longitude"]doubleValue];

    NSMutableArray* array = (NSMutableArray*)param;
    if (array == nil)
        return;
    [array addObject:expense];
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

- (NSArray*)getExpensesBetween:(NSDate *)startDate endDate:(NSDate *)endDate orderBy:(NSString *)fieldName assending :(BOOL)assending {
    NSString* start = formatSqlDate(startDate), *end = formatSqlDate(endDate);
    NSString* sql = [NSString stringWithFormat:@"select * from expense where Date >= %@ and date <= %@", start, end];
    if (fieldName) {
        NSString* order = @"DESC";
        if (assending)
            order = @"ASC";
        sql = [NSString stringWithFormat:@"%@ order by %@ %@", sql, fieldName, order];
    }
    NSMutableArray* array = [[[NSMutableArray alloc]init]autorelease];
    [[Database instance]execute:sql :self :@selector(translateExpense::) :array];
    return array;
}

- (NSArray *)getExpensesOfCategory:(int)categoryId fromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSString* start = formatSqlDate(startDate), * end = formatSqlDate(endDate);
    NSString* sql = [NSString stringWithFormat:@"select * from expense where categoryId = %d and date >= %@ and Date <= %@ order by Date desc", categoryId, start, end];
    NSMutableArray* arr = [NSMutableArray array];
    [[Database instance]execute:sql :self :@selector(translateExpense::) :arr];
    return arr;
}

- (void)translateExpenseDate : (NSMutableDictionary*)dict : (id)param {
    NSString* dateStr = [dict objectForKey:@"Date"];
    NSDate* date = dateFromSqlDate(dateStr);
    NSMutableArray* array = (NSMutableArray*)param;
    [array addObject:date];
}

- (NSArray *)getAvailableDatesBetween:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSString* start = formatSqlDate(startDate), *end = formatSqlDate(endDate);
    NSString* sql = [NSString stringWithFormat:@"select distinct substr(date, 0, 11) as date from expense where Date >= %@ and date <= %@ order by date desc", start, end];
    NSMutableArray* array = [NSMutableArray array];
    [[Database instance]execute:sql :self :@selector(translateExpenseDate::) :array];
    return array;
}

- (NSArray*)loadExpenseDates {
    NSString* sqlText = @"select distinct date from expense order by date desc";
    NSMutableArray* array = [NSMutableArray array];
    Database* db = [Database instance];
    [db execute:sqlText :self :@selector(translateExpenseDate::) :array];
    return array;
}

- (NSArray *)loadMonths{
    NSString* sql = @"select distinct strftime('%Y-%m', date) as month from expense order by month";
    NSMutableArray* array = [NSMutableArray array];
    Database* db = [Database instance];
    NSArray* records = [db execute:sql];
    for (NSDictionary* dict in records) {
        NSDate* firstDayOfMonth = dateFromMonthString([dict objectForKey:@"month"], YES);
        [array addObject: firstDayOfMonth];
    }
    if (array.count == 0)
        [array addObject:[NSDate date]];
    return array;    
}

- (BOOL)addExpense:(Expense *)expense {
    NSString* categoryIdStr = [NSString stringWithFormat:@"%d", expense.categoryId];
    NSString* amountStr = [NSString stringWithFormat:@"%f", expense.amount];
    NSString* dateStr = formatSqlDate(expense.date);
    NSString* notesStr = formatSqlString(expense.notes);
    NSString* pictureRefStr = formatSqlString(expense.pictureRef);
    NSString* useLocationStr = expense.useLocation ? @"1" : @"0";
    NSString* latitudeStr = [NSString stringWithFormat:@"%f", expense.latitude];
    NSString* longitudeStr = [NSString stringWithFormat:@"%f", expense.longitude];

    NSString* formatStr = @"insert into expense (categoryid, amount, date, notes, pictureref, uselocation, latitude, longitude) values (%@, %@, %@, %@, %@, %@, %@, %@)";
    NSString* sqlStr = [NSString stringWithFormat:formatStr, categoryIdStr, amountStr, dateStr, notesStr, pictureRefStr, useLocationStr, latitudeStr, longitudeStr];
    
    Database* db = [Database instance];
    return [db execute:sqlStr :nil :nil :nil];
}

- (BOOL)updateExpense:(Expense *)expense {
    NSString* idStr = [NSString stringWithFormat:@"%d", expense.expenseId];
    NSString* categoryIdStr = [NSString stringWithFormat:@"%d", expense.categoryId];
    NSString* amountStr = [NSString stringWithFormat:@"%f", expense.amount];
    NSString* dateStr = formatSqlDate(expense.date);
    NSString* notesStr = formatSqlString(expense.notes);
    NSString* pictureRefStr = formatSqlString(expense.pictureRef); 
    NSString* useLocationStr = expense.useLocation ? @"1" : @"0";
    NSString* latitudeStr = [NSString stringWithFormat:@"%f", expense.latitude];
    NSString* longitudeStr = [NSString stringWithFormat:@"%f", expense.longitude];
    
    
    NSString* sql = [NSString stringWithFormat:@"update expense set categoryid = %@, amount = %@, date = %@, notes = %@, pictureref = %@, uselocation = %@, latitude = %@, longitude = %@ where expenseid = %@", categoryIdStr, amountStr, dateStr, notesStr, pictureRefStr, useLocationStr, latitudeStr, longitudeStr, idStr];
    return [[Database instance]execute:sql :nil :nil :nil];
}

- (Expense *)getExpenseById:(NSInteger)expenseId {
    NSString* sql = [NSString stringWithFormat:@"select * from expense where expenseid = %d", expenseId];
    NSMutableArray* array = [NSMutableArray array];
    if (![[Database instance]execute:sql :self :@selector(translateExpense::) :array])
        return nil;
    if (array && array.count > 0)
        return [array objectAtIndex:0];
    return nil;
}

- (BOOL)deleteExpenseById:(NSInteger)expenseId {
    // check if there's an image attached
    Expense* expense = [self getExpenseById:expenseId];
    if (expense) {
        if (expense.pictureRef && expense.pictureRef.length > 0)
            [self deleteImageNote:expense.pictureRef];
    }
    NSString * sqlStr = [NSString stringWithFormat: @"delete from expense where expenseid = %d", expenseId];
    Database* db = [Database instance];
    return [db execute:sqlStr :nil :nil :nil];
}

- (NSString*)generateImageFileName {
    return [NSString stringWithFormat: @"%@.jpg", generateUUID()];
}

#pragma mark - image note

- (NSString *)saveImageNote:(UIImage*)image {
    if (!image)
        return nil;
    NSString* imgNoteDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageNotes"];
    NSString* fileName = [self generateImageFileName];
    NSString* imgFileName = [imgNoteDir stringByAppendingPathComponent:fileName];
    if (![UIImageJPEGRepresentation(image, 0.8) writeToFile:imgFileName atomically:YES])
        return nil;
    return fileName;
}

- (UIImage*)loadImageNote:(NSString*)fileName {
    if (!fileName)
        return nil;
    NSString* imgNoteDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageNotes"];
    NSString* imgFileName = [imgNoteDir stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:imgFileName])
        return nil;
    
    return [UIImage imageWithContentsOfFile:imgFileName];
}

- (void)deleteImageNote:(NSString *)fileName {
    if (!fileName)
        return;
    NSString* imgNoteDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageNotes"];
    NSString* imgFileName = [imgNoteDir stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:imgFileName])
        return;
    [[NSFileManager defaultManager]removeItemAtPath:imgFileName error:nil];
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

+ (NSDictionary *)groupExpensesByDate:(NSArray *)expenses {
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:expenses.count];
    for (Expense* e in expenses) {
        if (![dict objectForKey:DATESTR(e.date)])
            [dict setObject:[NSMutableArray array] forKey:DATESTR(e.date)];
        NSMutableArray* arr = [dict objectForKey:DATESTR(e.date)];
        [arr addObject:e];
    }
    return dict;
}

+ (NSDate *)firstDayOfExpense {
    NSString* sql = @"select min(date) MinDate from expense";
    NSArray* records = [[Database instance]execute:sql];
    if (!records || records.count == 0)
        return nil;
    NSDictionary* record = [records objectAtIndex:0];
    if ([record objectForKey:@"MinDate"] == nil)
        return nil;
    NSDate* date = normalizeDate(dateFromSqlDate([record objectForKey:@"MinDate"]));
    return date;
}

+ (NSDate*)lastDayOfExpense {
    NSString* sql = @"select max(date) MaxDate from expense";
    NSArray* records = [[Database instance]execute:sql];
    if (!records || records.count == 0)
        return nil;
    NSDictionary* record = [records objectAtIndex:0];
    if ([record objectForKey:@"MaxDate"] == nil)
        return nil;
    NSDate* date = normalizeDate(dateFromSqlDate([record objectForKey:@"MaxDate"]));
    return date;    
}

@end
