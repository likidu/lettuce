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

extern NSString* formatSqlString(NSString* sourceStr);
extern NSString* formatSqlDate(NSDate* date);
extern NSString* formatSqlYearMonth(NSDate* date);
extern NSString* formatDisplayDate(NSDate* date);
extern NSString* formatMonthString(NSDate* dayOfMonth);
extern NSString* formatMonthDayString(NSDate* day);
extern NSString* shortDateString(NSDate* date);
extern NSDate*   dateFromSqlDate(NSString* dateStr);
extern NSDate*   dateFromMonthString(NSString* monthStr, BOOL isFirstDay);
extern NSDate*   firstDayOfMonth(NSDate* dayOfMonth);
extern NSDate*   lastDayOfMonth(NSDate* dayOfMonth);
extern BOOL      isWeekend(NSDate* date);
extern NSDate*   normalizeDate(NSDate* date);
extern BOOL      compareDate(NSDate* date1, NSDate* date2);
extern NSArray*  getDaysOfMonth(NSDate* dayOfMonth);
extern NSArray*  getDatesBetween(NSDate* startDate, NSDate* endDate);
extern int       getDayAmountOfMonth(NSDate* dayOfMonth);
extern BOOL      isSameDay(NSDate* day1, NSDate* day2);
extern BOOL      isSameMonth(NSDate* day1, NSDate* day2);
extern int       getNumberOfDaysInMonth(int month, int year);
extern NSString* formatAmount(double amount, BOOL withPrecision);

extern void      makeToolButton(UIButton* button);
extern void      setButtonTitleForStates(UIButton* button, NSString* title, UIControlState state);
extern void      setButtonTitleColorForStates(UIButton* button, UIColor* color, UIControlState state);
extern void      setButtonTitleShadowColorForStates(UIButton* button, UIColor* color, UIControlState state);
extern void      setButtonImageForStates(UIButton* button, UIImage* image, UIControlState state);

#define DATESTR(x) shortDateString(x)

#endif