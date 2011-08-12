//
//  SecondViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthPickerController.h"

@protocol DateRangeResponder <NSObject>

@required
- (void)setStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end


@interface SecondViewController : UIViewController <MonthPickerControllerDelegate>{

}

@property(nonatomic, retain) NSArray* months;
@property(nonatomic, retain) NSDate* currentMonth;
@property(nonatomic, retain) MonthPickerController* monthPicker;

@property(nonatomic, retain) IBOutlet UIView* monthPickerPlaceholder;
@property(nonatomic, retain) IBOutlet UIView* switchPlaceholder;
@property(nonatomic, retain) IBOutlet UIView* expenseSwitch;
@property(nonatomic, retain) IBOutlet UIView* filterSwitch;
@property(nonatomic, retain) IBOutlet UIButton* filterButton;

- (IBAction)onEdit:(id)sender;
- (IBAction)onFilter;

@end
