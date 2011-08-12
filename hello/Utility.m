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

NSString* formatMonthString(NSDate* dayOfMonth) {
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat: @"yyyy年M月"];
    return [formatter stringFromDate:dayOfMonth];
}

NSDate* dateFromSqlDate(NSString* dateStr){    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone  timeZoneWithAbbreviation:@"UTC"]];
    return [formatter dateFromString:dateStr];
}

NSDate* dateFromMonthString(NSString* monthStr, BOOL isFirstDay) {
    NSArray* subStrs = [monthStr componentsSeparatedByString:@"-"];
    if (subStrs.count != 2)
        return nil;
    NSDateComponents* comp = [[[NSDateComponents alloc]init]autorelease];
    int year = [[subStrs objectAtIndex:0]intValue];
    int month = [[subStrs objectAtIndex:1]intValue];

    int day = 1;
    if (!isFirstDay) {
        day = getNumberOfDaysInMonth(month, year);
    }
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    return [[NSCalendar currentCalendar]dateFromComponents:comp];
}

NSDate* firstDayOfMonth(NSDate* dayOfMonth) {
    return dateFromMonthString(formatMonthString(dayOfMonth), YES);
}

NSDate* lastDayOfMonth(NSDate* dayOfMonth) {
    return dateFromMonthString(formatMonthString(dayOfMonth), NO);
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

bool isLeapYear(int year) {
    if (year % 4)
        return false;
    if (year % 100)
        return true;
    if (year % 400)
        return false;
    return true;
}

int getNumberOfDaysInMonth(int month, int year) {
    switch (month) {
        case 2:
            if (isLeapYear(year))
                return 29;
            else
                return 28;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
            break;
            
        default:
            return 31;
            break;
    }
}

int getDayAmountOfMonth(NSDate* dayOfMonth) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:dayOfMonth];
    return getNumberOfDaysInMonth(components.month, components.year);
}


NSArray* getDaysOfMonth(NSDate* dayOfMonth) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSWeekdayCalendarUnit fromDate:dayOfMonth];
    NSMutableArray* array = [NSMutableArray arrayWithCapacity: getDayAmountOfMonth(dayOfMonth)];
    for (int i = 0; i < array.count; i++) {
        components.day = i;
        int dayCode = 0;
        if (components.weekday == 1 || components.weekday == 7)
            dayCode = 1;
        [array insertObject:[NSNumber numberWithInt:dayCode ] atIndex:i];
    }
    return [NSArray arrayWithArray:array];
}

BOOL isSameDay(NSDate* day1, NSDate* day2){
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day1];
    NSDateComponents* comp2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day2];
    return (comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day);
}

BOOL isSameMonth(NSDate* day1, NSDate* day2) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day1];
    NSDateComponents* comp2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day2];
    return (comp1.year == comp2.year && comp1.month == comp2.month);
}

void makeToolButton(UIButton* button) {
    CGRect titleFrame = [button titleRectForContentRect:button.frame];
    CGRect imageFrame = [button imageRectForContentRect:button.frame];
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageFrame.size.width, -imageFrame.size.height, 0.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-titleFrame.size.height, 0.0, 0.0, -titleFrame.size.width);
}

void setButtonTitleForStates(UIButton* button, NSString* title, UIControlState state) {
    [button setTitle:title forState:UIControlStateNormal];
    if (state & UIControlStateHighlighted)
        [button setTitle:title forState:UIControlStateHighlighted];
    if (state & UIControlStateSelected)
        [button setTitle:title forState:UIControlStateSelected];
    if (state & UIControlStateDisabled)
        [button setTitle:title forState:UIControlStateDisabled];
}

void setButtonTitleColorForStates(UIButton* button, UIColor* color, UIControlState state) {
    [button setTitleColor:color forState:UIControlStateNormal];
    if (state & UIControlStateHighlighted)
        [button setTitleColor:color forState:UIControlStateHighlighted];
    if (state & UIControlStateSelected)
        [button setTitleColor:color forState:UIControlStateSelected];
    if (state & UIControlStateDisabled)
        [button setTitleColor:color forState:UIControlStateDisabled];
}

void setButtonTitleShadowColorForStates(UIButton* button, UIColor* color, UIControlState state) {
    [button setTitleShadowColor:color forState:UIControlStateNormal];
    if (state & UIControlStateHighlighted)
        [button setTitleShadowColor:color forState:UIControlStateHighlighted];
    if (state & UIControlStateSelected)
        [button setTitleShadowColor:color forState:UIControlStateSelected];
    if (state & UIControlStateDisabled)
        [button setTitleShadowColor:color forState:UIControlStateDisabled];
}

void setButtonImageForStates(UIButton* button, UIImage* image, UIControlState state) {
    [button setImage:image forState:UIControlStateNormal];
    if (state & UIControlStateHighlighted)
        [button setImage:image forState:UIControlStateHighlighted];
    if (state & UIControlStateSelected)
        [button setImage:image forState:UIControlStateSelected];
    if (state & UIControlStateDisabled)
        [button setImage:image forState:UIControlStateDisabled];
}



