//
//  Utility.h
//  hello
//
//  Created by Rome Lee on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef UTILITY_H
#define UTILITY_H

#define TIME_INTERVAL_HOUR      3600
#define TIME_INTERVAL_DAY       86400
#define CURRENCY_CODE           @"￥"

extern NSString* formatSqlString(NSString* sourceStr);
extern NSString* formatSqlDate(NSDate* date);
extern NSString* formatSqlYearMonth(NSDate* date);
extern NSString* formatDisplayDate(NSDate* date);
extern NSString* formatMonthString(NSDate* dayOfMonth);
extern NSString* formatMonthDayString(NSDate* day);
extern NSString* formatYearString(NSDate* day);
extern NSString* formatMonthOnlyString(NSDate* day);
extern NSString* shortDateString(NSDate* date);
extern NSString* formatDateToString(NSDate* date, NSString* formatString, NSTimeZone* currentTimeZone);
extern NSDate*   dateFromSqlDate(NSString* dateStr);
extern NSDate*   dateFromMonthString(NSString* monthStr, BOOL isFirstDay);
extern NSDate*   firstDayOfMonth(NSDate* dayOfMonth);
extern NSDate*   lastDayOfMonth(NSDate* dayOfMonth);
extern NSDate*   firstMonthOfYear(NSDate* dayOfYear);
extern NSDate*   lastMonthOfYear(NSDate* dayOfYear);
extern NSDate* dateFromFormatString(NSString* dateString, NSString* formatString, NSTimeZone* currentTimeZone);
extern BOOL      isWeekend(NSDate* date);
extern NSDateComponents* getDateComponentsWithoutTime(NSDate* date);
extern NSDate*   normalizeDate(NSDate* date);
extern BOOL      compareDate(NSDate* date1, NSDate* date2);
extern NSArray*  getDaysOfMonth(NSDate* dayOfMonth);
extern NSArray*  getDatesBetween(NSDate* startDate, NSDate* endDate);
extern int       getDayAmountOfMonth(NSDate* dayOfMonth);
extern NSArray*  getMonthsBetween(NSDate* dayOfMonth1, NSDate* dayOfMonth2, BOOL ignoreDayComponent);
extern BOOL      isSameDay(NSDate* day1, NSDate* day2);
extern BOOL      isSameMonth(NSDate* day1, NSDate* day2);
extern BOOL      isSameYear(NSDate* day1, NSDate* day2);
extern int       compareMonth(NSDate* dayOfMonth1, NSDate* dayOfMonth2);
extern NSDate*   minDay(NSDate* day1, NSDate* day2);
extern NSDate*   maxDay(NSDate* day1, NSDate* day2);
extern int       getNumberOfDaysInMonth(int month, int year);
extern NSString* formatAmount(double amount, BOOL withPrecision);
extern int       getDay(NSDate* day);
extern void      cancelNotifications();
extern void      makeToolButton(UIButton* button);
extern void      makeDropButton(UIButton* button);
extern void      setButtonTitleForStates(UIButton* button, NSString* title, UIControlState state);
extern void      setButtonTitleColorForStates(UIButton* button, UIColor* color, UIControlState state);
extern void      setButtonTitleShadowColorForStates(UIButton* button, UIColor* color, UIControlState state);
extern void      setButtonImageForStates(UIButton* button, UIImage* image, UIControlState state);
extern NSString* generateUUID();
                                      
extern NSArray* getWeekdayStringArray();
extern void      flashView(UIView* view);
extern void     scheduleNotificationWithItem();
extern NSArray* getTimeArrayWithMinutesInteval(int minutesinterval);
#define PRECISION 0.000001
#define FUZZYEQUAL(x,y) (ABS(((x)-(y)))<=PRECISION)

#define DATESTR(x) shortDateString(x)

@interface UIViewController (ModalViewExtension)

- (UIViewController*)rootViewController;
+ (UIViewController*)topViewController;

@end

@interface UIView (FirstResponder)

- (UIView*)findFirstResponder;
    
@end

@interface NSArray(ReverseExtension)

- (NSArray*)reverse;

@end

@interface Dimmer : NSObject

+ (Dimmer*)dimmerWithView:(UIView*)view;

- (id)initWithView:(UIView*)view;

- (void)show;
- (void)hide;

@property(nonatomic,assign) float duration;

@end

#endif