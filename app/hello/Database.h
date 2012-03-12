/*
 *  Database.h
 *  lettuce
 *
 *  Created by Rome Lee on 11-3-5.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once

@interface Database : NSObject {
@private
    sqlite3 *_db;
}

+ (Database*)instance;

- (BOOL)load:(NSString*)dbPath;
- (void)hibernate;

- (BOOL)execute : (NSString*)sqlText : (id)object : (SEL)recordTranslator : (id)translatorParam;

- (NSArray*)execute:(NSString*)sqlString;

@end

