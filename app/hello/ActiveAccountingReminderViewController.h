//
//  ActiveAccountingReminderViewController.h
//  woojuu
//
//  Created by Liangying Wei on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveAccountingReminderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>{    
}

enum  ReminderType{
    Daily = 0,
    Weekly = 1,
};

@property (retain, nonatomic) IBOutlet UITableView *accountingReminderTableView;
@property (retain, nonatomic) IBOutlet UITableView *detailedReminderTableView;
@property (retain, nonatomic) IBOutlet UISwitch *yesNoSwitch;
@property (retain, nonatomic) IBOutlet UIPickerView *dailyPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *weeklyPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *itemPicker;
@property (retain, nonatomic) NSArray * reminderTypeData;
@property (retain, nonatomic) NSArray * dailyTimeData;
@property (retain, nonatomic) NSArray * weeklyData;
@property (retain, nonatomic) UIView * activeFloatingView;
@property (retain, nonatomic) NSString * reminderTime;
@property enum ReminderType currentReminderType;
@property NSUInteger currentWeekIndex;
@property NSUInteger currentTimeIndex;
+ (ActiveAccountingReminderViewController*) createInstance;
@end

