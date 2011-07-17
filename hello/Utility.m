//
//  Utility.m
//  hello
//
//  Created by Rome Lee on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

NSString* formatSqlString(NSString* sourceStr) {
    if (sourceStr == nil)
        return @"NULL";
    
    NSString* encodedStr = [sourceStr stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    return [NSString stringWithFormat:@"'%@'", encodedStr];
}

NSString* formatSqlDate(NSDate* date) {
    if (date == nil)
        return @"NULL";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString* dateStr = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"date('%@')", dateStr];
}

NSString* formatSqlYearMonth(NSDate* date) {
    if (date == nil)
        return @"NULL";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
}

NSString* formatDisplayDate(NSDate* date) {
    if (date == nil)
        return @"NULL";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setLocale:[[[NSLocale alloc]initWithLocaleIdentifier: @"zh_CN"]autorelease]];
    [formatter setDateStyle: NSDateFormatterFullStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    return [formatter stringFromDate:date];
}

NSDate* dateFromSqlDate(NSString* dateStr){    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone  timeZoneWithAbbreviation:@"UTC"]];
    return [formatter dateFromString:dateStr];
}

BOOL isWeekend(NSDate* date) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSWeekdayOrdinalCalendarUnit| NSWeekdayCalendarUnit | NSWeekCalendarUnit fromDate:date];
    NSLog(@"%d, %d, %d", components.week, components.weekday, components.weekdayOrdinal);
    if (components.weekday == 1 || components.weekday == 7)
        return TRUE;
    return NO;
}

BOOL compareDate(NSDate* date1, NSDate* date2) {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp1 = [cal components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: date1];
    NSDateComponents* comp2 = [cal components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate: date2];
    date1 = [cal dateFromComponents:comp1];
    date2 = [cal dateFromComponents:comp2];
    return ([date1 compare:date2] == NSOrderedSame);
}

