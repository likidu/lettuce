//
//  HistoryRootView.m
//  woojuu
//
//  Created by Lee Rome on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryRootView.h"
#import "Statistics.h"
#import "ExpenseByCategoryViewController.h"

@interface HistoryRootView()

@property(nonatomic,retain) FullScreenViewController* fullScreenController;

@end

@implementation HistoryRootView

@synthesize overviewByMonth;
@synthesize overviewByCategory;
@synthesize tableViewPlaceHolder;
@synthesize viewByMonthButton;
@synthesize viewByCategoryButton;
@synthesize navigationButton;
@synthesize yearPicker;
@synthesize fullScreenController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNeedsLayout];
    
    // setup the navigation item
    makeDropButton(self.navigationButton);
    self.navigationButton.titleLabel.text = formatYearString([NSDate date]);
    self.navigationItem.titleView = self.navigationButton;
    self.navigationItem.title = formatYearString([NSDate date]);
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    // create and initialize the overview
    self.overviewByMonth = [OverviewByYearViewController createInstance];
    [self.view addSubview: overviewByMonth.view];
    [self.view bringSubviewToFront:overviewByMonth.view];
    overviewByMonth.view.frame = tableViewPlaceHolder.frame;
    [overviewByMonth.view layoutSubviews];
    
    self.overviewByCategory = [OverviewByCategoryViewController createInstance];
    [self.view addSubview: overviewByCategory.view];
    [self.view bringSubviewToFront:overviewByCategory.view];
    overviewByCategory.view.frame = tableViewPlaceHolder.frame;
    [overviewByCategory.view layoutSubviews];
    overviewByCategory.view.hidden = YES;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.overviewByMonth = nil;
    self.overviewByCategory = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    if (viewByMonthButton.selected) {
        [overviewByMonth reload];
    }
    else {
        [overviewByCategory reload];
    }
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)onViewByMonth {
    if (!viewByMonthButton.selected) {
        viewByMonthButton.selected = YES;
        viewByCategoryButton.selected = NO;
        
        overviewByMonth.view.hidden = NO;
        overviewByCategory.view.hidden = YES;
    }
}

- (void)onViewByCategory {
    if (!viewByCategoryButton.selected) {
        viewByCategoryButton.selected = YES;
        viewByMonthButton.selected = NO;
        
        overviewByCategory.view.hidden = NO;
        overviewByMonth.view.hidden = YES;
    }
}

- (void)onPickYear {
    if (!self.fullScreenController) {
        self.fullScreenController = [[[FullScreenViewController alloc]initWithNibName:@"FullScreenViewController" bundle:[NSBundle mainBundle]]autorelease];  
        self.fullScreenController.delegate = self;
    }

    [self.fullScreenController presentView:self.yearPicker];
}

#pragma mark - full screen view delegate

- (BOOL)shouldDismissOnBackgroundViewTapped {
    return YES;
}

- (void)dismissed {
    self.fullScreenController = nil;
}

#pragma mark - year picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 1;
}

#pragma mark - year pickder view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"2012";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.fullScreenController dismiss];
}

@end
