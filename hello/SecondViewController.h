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

enum SwitchArea {
    kMonthPicker,
    kExpenseSaving,
    kFilter
};

@interface SecondViewController : UIViewController <MonthPickerControllerDelegate, TableUpdateDelegate>{
    NSMutableArray* tables_;
    int activeTable;
    int activeSwitch;
    BOOL viewInitialized;
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
@property(nonatomic, retain) IBOutlet UIView* switchPlaceholder;
@property(nonatomic, retain) IBOutlet UIButton* monthButton;
@property(nonatomic, retain) IBOutlet UIButton* byAmountButton;
@property(nonatomic, retain) IBOutlet UIButton* byCategoryButton;

- (IBAction)onEdit:(id)sender;
- (IBAction)onFilter;
- (IBAction)onMonthButton;
- (IBAction)onSwitchButtonExpense;
- (IBAction)onSwitchButtonSaving;
- (IBAction)onSwitchButtonByAmount;
- (IBAction)onSwitchButtonByCategory;

@end
