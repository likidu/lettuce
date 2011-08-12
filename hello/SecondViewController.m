//
//  SecondViewController.m
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "ExpenseManager.h"
#import "CategoryManager.h"
#import "Database.h"
#import "Statistics.h"
#import "MonthPickerController.h"

@implementation SecondViewController

@synthesize months;
@synthesize currentMonth;
@synthesize monthPicker;
@synthesize monthPickerPlaceholder;
@synthesize switchPlaceholder;
@synthesize expenseSwitch;
@synthesize filterSwitch;
@synthesize filterButton;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    expenseSwitch.frame = switchPlaceholder.frame;
    filterSwitch.frame = CGRectOffset(switchPlaceholder.frame, switchPlaceholder.frame.size.width, 0.0);
    filterSwitch.alpha = 0.0;
    [self.view addSubview:expenseSwitch];
    [self.view addSubview:filterSwitch];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    /*if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [plotView removeFromSuperview];
    }
    else {
        plotView.frame = self.view.frame;
        [self.view addSubview:plotView];
        [self.view bringSubviewToFront:plotView];
    }*/
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.monthPickerPlaceholder = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    ExpenseManager* expMan = [ExpenseManager instance];
    
    // show the month list
    if (monthPicker)
        [monthPicker.view removeFromSuperview];
    self.months = [expMan loadMonths];
    self.currentMonth = [months lastObject];
    self.monthPicker = [MonthPickerController pickerWithMonths:months];
    monthPicker.view.frame = monthPickerPlaceholder.frame;
    [monthPicker reload];
    monthPicker.delegate = self;
    [self.view addSubview:monthPicker.view];
    [self.view bringSubviewToFront:monthPicker.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [monthPicker pickMonth:[months lastObject]];
}

- (void)onEdit:(id)sender {
    UIButton* button = sender;
    if (!button)
        return;
    BOOL isEditing = button.selected;

    button.selected = !isEditing;
}

- (void)onFilter {
    filterButton.selected = !filterButton.selected;
    [UIView animateWithDuration:0.2
                     animations:^{
                         float offset = -switchPlaceholder.frame.size.width;
                         if (filterButton.selected) {
                             expenseSwitch.alpha = 0.0;
                             filterSwitch.alpha = 1.0;
                         }
                         else {
                             expenseSwitch.alpha = 1.0;
                             filterSwitch.alpha = 0.0;
                             offset = -offset;
                         }
                         expenseSwitch.frame = CGRectOffset(expenseSwitch.frame, offset, 0.0);
                         filterSwitch.frame = CGRectOffset(filterSwitch.frame, offset, 0.0);
                     }];
}

- (void)monthPicked:(NSDate *)dayOfMonth {
    if (isSameMonth(dayOfMonth, currentMonth))
        return;
    self.currentMonth = dayOfMonth;
}

- (void)dealloc
{
    [super dealloc];
}

@end
