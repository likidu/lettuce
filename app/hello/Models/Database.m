/*
 *  Database.cpp
 *  lettuce
 *
 *  Created by Rome Lee on 11-3-5.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */


#import "Database.h"

static Database *g_instance = nil;

@implementation Database

+ (Database*)instance {
    if (g_instance == nil) {
        g_instance = [[Database alloc]init];
    }
    return g_instance;
}

- (Database*)init {
    _db = nil;
    return self;
}

- (BOOL)load:(NSString*)dbPath {
    if (_db != nil) {
        if (sqlite3_close(_db) != SQLITE_OK)
            return NO;
        _db = nil;
    }

    sqlite3 *db = NULL;
    if (sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK)
        return NO;
    
    _db = db;
    
    return YES;
}

- (void)hibernate {
    
}

typedef struct {
    id object;
    SEL selector;
    id param;
}_RecordHandlerParam;

int recordHandler(void* param, int columnCount, char** values, char** keys) {
    _RecordHandlerParam* translator = (_RecordHandlerParam*)param;
    if (translator == nil)
        return 1; // non zero to abort
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (int i = 0; i < columnCount; i++) {
        NSString* value = values[i] ? [NSString stringWithUTF8String:values[i]] : nil;
        NSString* key = keys[i] ? [NSString stringWithUTF8String:keys[i]] : nil;
        if (value && key)
            [dict setObject: value forKey:key];
    }
    [translator->object performSelector:translator->selector withObject:dict withObject:translator->param];
    return 0;
}

- (BOOL)execute:(NSString *)sqlText : (id)object : (SEL)recordTranslator :(id)translatorParam{
    NSLog(@"%@", sqlText);
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    char* errMsg = NULL;
    _RecordHandlerParam param;
    BOOL useTranslator = object && recordTranslator;
    
    if (useTranslator) {
        param.object = object;
        param.selector = recordTranslator;
        param.param = translatorParam;
    }
    _RecordHandlerParam* translator = &param;
    sqlite3_callback nativeCallback = &recordHandler;
    if (!useTranslator) {
        translator = NULL;
        nativeCallback = NULL;
    }

    const char* sql = [sqlText UTF8String];
    if (sqlite3_exec(_db, sql, nativeCallback, translator, &errMsg) != SQLITE_OK) {
        sqlite3_free(errMsg);
        [pool release];
        return NO;
    }
    [pool release];
    return YES;
}

int recordHandler2(void* param, int columnCount, char** values, char** keys) {
    NSMutableArray* records = (NSMutableArray*)param;
    if (!records)
        return -1; // non-zero to abort
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:1];
    for (int i = 0; i < columnCount; i++) {
        NSString* value = values[i] ? [NSString stringWithUTF8String:values[i]] : nil;
        NSString* key = keys[i] ? [NSString stringWithUTF8String:keys[i]] : nil;
        if (value && key)
            [dict setObject: value forKey:key];
    }
    [records addObject:dict];
    return 0;
}

- (NSArray *)execute:(NSString *)sqlString {
    const char* sql = [sqlString UTF8String];
    char* errMsg = NULL;
    NSMutableArray* records = [NSMutableArray array];
    if (sqlite3_exec(_db, sql, &recordHandler2, records, &errMsg) != SQLITE_OK) {
        NSLog(@"%@", [NSString stringWithCString:errMsg encoding:NSStringEncodingConversionAllowLossy]);
        sqlite3_free(errMsg);
        return nil;
    }
    return records;
}

@end

