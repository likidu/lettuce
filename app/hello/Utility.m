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

NSString* shortDateString(NSDate* date) {
    if (date == nil)
        return @"NULL";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString* dateStr = [formatter stringFromDate:date];
    return dateStr;
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

NSString* formatMonthOnlyString(NSDate* day) {
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat: @"M月"];
    return [formatter stringFromDate:day];
}

NSString* formatYearString(NSDate* day) {
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat: @"yyyy年"];
    return [formatter stringFromDate:day];
}

NSString* formatMonthDayString(NSDate* day) {
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat: @"M/d"];
    return [formatter stringFromDate:day];    
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
    return dateFromMonthString(formatSqlYearMonth(dayOfMonth), YES);
}

NSDate* lastDayOfMonth(NSDate* dayOfMonth) {
    return dateFromMonthString(formatSqlYearMonth(dayOfMonth), NO);
}

NSDate* firstMonthOfYear(NSDate* dayOfYear) {
    NSDateComponents* comps = getDateComponentsWithoutTime(dayOfYear);
    comps.month = 1;
    return [[NSCalendar currentCalendar]dateFromComponents:comps];
}

NSDate* lastMonthOfYear(NSDate* dayOfYear) {
    NSDateComponents* comps = getDateComponentsWithoutTime(dayOfYear);
    comps.month = 12;
    return [[NSCalendar currentCalendar]dateFromComponents:comps];
}

BOOL isWeekend(NSDate* date) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSWeekdayOrdinalCalendarUnit| NSWeekdayCalendarUnit | NSWeekCalendarUnit fromDate:date];
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

NSDateComponents* getDateComponentsWithoutTime(NSDate* date) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:date];
    return comp;
}

NSArray* getMonthsBetween(NSDate* dayOfMonth1, NSDate* dayOfMonth2) {
    NSDate* startDate = normalizeDate(dayOfMonth1);
    NSDate* endDate = normalizeDate(dayOfMonth2);
    if ([startDate compare:endDate] != NSOrderedAscending)
        return nil;
    NSMutableArray* array = [NSMutableArray array];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* currentDate = startDate;
    while ([currentDate compare:endDate] != NSOrderedDescending) {
        [array addObject:currentDate];
        NSDateComponents* comps = getDateComponentsWithoutTime(currentDate);
        if (comps.month == 12) {
            comps.year++;
            comps.month = 1;
        }
        else {
            comps.month++;
        }
        currentDate = [calendar dateFromComponents:comps];
    }
    return array;
}

NSDate* normalizeDate(NSDate* date) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:date];
    return [calendar dateFromComponents:comp];
}

NSArray*  getDatesBetween(NSDate* startDate, NSDate* endDate) {
    startDate = normalizeDate(startDate);
    endDate = normalizeDate(endDate);
    if ([endDate timeIntervalSinceDate:startDate] < 0)
        return nil;
    NSMutableArray* array = [NSMutableArray array];
    double interval = 0.0;
    do {
        [array addObject:startDate];
        startDate = [startDate dateByAddingTimeInterval:TIME_INTERVAL_DAY];
        interval = [endDate timeIntervalSinceDate:startDate];
    }while (FUZZYEQUAL(interval, 0.0) || interval > TIME_INTERVAL_HOUR);
    return array;
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

BOOL isSameYear(NSDate* day1, NSDate* day2) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day1];
    NSDateComponents* comp2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:day2];
    return (comp1.year == comp2.year);    
}

int compareMonth(NSDate* dayOfMonth1, NSDate* dayOfMonth2) {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:dayOfMonth1];
    NSDateComponents* comp2 = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit fromDate:dayOfMonth2];
    if (comp1.year > comp2.year)
        return 1;
    if (comp1.year < comp2.year)
        return -1;
    if (comp1.month > comp2.month)
        return 1;
    if (comp1.month < comp2.month)
        return -1;
    return 0;
}

void makeToolButton(UIButton* button) {
    CGRect titleFrame = button.titleLabel.frame;
    CGRect imageFrame = button.imageView.frame;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageFrame.size.width, -imageFrame.size.height, 0.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-titleFrame.size.height, 0.0, 0.0, -titleFrame.size.width);
}

void makeDropButton(UIButton* button) {
    CGRect titleFrame = button.titleLabel.frame;
    CGRect imageFrame = button.imageView.frame;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageFrame.size.width, 0.0, imageFrame.size.width);
    button.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleFrame.size.width, 0.0, -titleFrame.size.width);
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


NSString* formatAmount(double amount, BOOL withPrecision) {
    if (withPrecision)
        return [NSString stringWithFormat:@"￥%.2f", amount];

    return [NSString stringWithFormat:@"￥%.f", amount];;
}

NSDate*   minDay(NSDate* day1, NSDate* day2) {
    return ([day1 timeIntervalSinceDate:day2] < 0 ? day1 : day2);
}
NSDate*   maxDay(NSDate* day1, NSDate* day2) {
    return ([day1 timeIntervalSinceDate:day2] > 0 ? day1 : day2);
}

NSString* generateUUID() {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString* uuid = [NSString stringWithString:(NSString*)newUniqueIdString];
	CFRelease(newUniqueId);
	CFRelease(newUniqueIdString);
    return uuid;
}

int getDay(NSDate* day) {
    NSDateComponents* components = [[NSCalendar currentCalendar]components:NSDayCalendarUnit fromDate:day];
    return components.day;
}

void flashView(UIView* view) {
    UIColor* originalColor = view.backgroundColor;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^(void){
        view.backgroundColor = [UIColor redColor];
    } completion: ^(BOOL finished){
        if (finished) {
            view.backgroundColor = originalColor;
        }
    }];
}


@implementation UIViewController(ModalViewExtension)

- (UIViewController *)rootViewController {
    UIApplication* app = [UIApplication sharedApplication];
    UIViewController* rootVc = app.keyWindow.rootViewController;
    if (self.parentViewController == rootVc)
        return self;
    return rootVc;
}

@end

@implementation UIView(FirstResponder)

- (UIView *)findFirstResponder {
    if (self.isFirstResponder)
        return self;
    for (UIView* view in self.subviews) {
        UIView* firstResponder = [view findFirstResponder];
        if (firstResponder)
            return firstResponder;
    }
    return nil;
}

@end