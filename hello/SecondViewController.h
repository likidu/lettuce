//
//  SecondViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPickerController.h"
#import "TableViewProtocol.h"

enum TableIds {
    kExpense = 0,
    kSaving = 1,
    kByAmount = 2,
    kByCategory = 3
};

enum SwitchArea {
    kMonthPicker,
    kExpenseSaving,
    kFilter
};

@interface SecondViewController : UIViewController <MonthPickerControllerDelegate>{
    NSMutableArray* tables_;
    int activeTable;
    int activeSwitch;
}

@property(nonatomic, retain) NSArray* months;
@property(nonatomic, retain) NSDate* currentMonth;
@property(nonatomic, retain) MonthPickerController* monthPicker;

@property(nonatomic, retain) IBOutlet UIView* monthPickerPlaceholder;
@property(nonatomic, retain) IBOutlet UIButton* filterButton;
@property(nonatomic, retain) IBOutlet UIButton* editButton;
@property(nonatomic, retain) IBOutlet UIView* tablePlaceholder;
@property(nonatomic, retain) IBOutlet UIButton* switchButtonExpense;
@property(nonatomic, retain) IBOutlet UIButton* switchButtonSaving;
@property(nonatomic, retain) IBOutlet UISegmentedControl* filterSegment;
@property(nonatomic, retain) IBOutlet UIView* switchPlaceholder;
@property(nonatomic, retain) IBOutlet UIButton* monthButton;

- (IBAction)onEdit:(id)sender;
- (IBAction)onFilter;
- (IBAction)onSwitchButtonExpense;
- (IBAction)onSwitchButtonSaving;
- (IBAction)onFilterSegmentChange;
- (IBAction)onMonthButton;

@end
