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
#import "UIViewController+UtilityExtension.h"
#import "MonthViewRoot.h"
#import "SingleCategoryByYearView.h"

@interface HistoryRootView()

@property(nonatomic,retain) FullScreenViewController* fullScreenController;
@property(nonatomic,retain) NSArray* availableYears;
@property(nonatomic,retain) NSDate* currentYear;

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
@synthesize availableYears;
@synthesize currentYear;

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
    self.navigationItem.titleView = self.navigationButton;
    self.navigationItem.title = formatYearString([NSDate date]);
    // create and initialize the overview
    self.overviewByMonth = (OverviewByYearViewController*)[OverviewByYearViewController instanceFromNib];
    self.overviewByMonth.delegate = self;
    [self.tableViewPlaceHolder addSubview: overviewByMonth.view];
    [self.tableViewPlaceHolder bringSubviewToFront:overviewByMonth.view];
    overviewByMonth.view.frame = tableViewPlaceHolder.bounds;
    [overviewByMonth.view layoutSubviews];
    
    self.overviewByCategory = (OverviewByCategoryViewController*)[OverviewByCategoryViewController instanceFromNib];
    self.overviewByCategory.delegate = self;
    [self.tableViewPlaceHolder addSubview: overviewByCategory.view];
    [self.tableViewPlaceHolder bringSubviewToFront:overviewByCategory.view];
    overviewByCategory.view.frame = tableViewPlaceHolder.bounds;
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
    self.availableYears = [Statistics getAvailableYears];
    if (self.currentYear == nil || ![self.availableYears containsObject:self.currentYear])
        self.currentYear = [self.availableYears lastObject];
    [self reloadAll];
}

- (void)reloadAll {
    NSDate* firstDayOfYear = firstDayOfMonth(firstMonthOfYear(self.currentYear));
    NSDate* lastDayOfYear = lastDayOfMonth(lastMonthOfYear(self.currentYear));
    [overviewByMonth setStartDate:firstDayOfYear endDate:lastDayOfYear];
    [overviewByCategory setStartDate:firstDayOfYear endDate:lastDayOfYear];
    [self.navigationButton setTitle:formatYearString(self.currentYear) forState:UIControlStateNormal];
    makeDropButton(self.navigationButton);
    self.navigationItem.title = formatYearString(self.currentYear);
    
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
        [overviewByMonth reload];
    }
}

- (void)onViewByCategory {
    if (!viewByCategoryButton.selected) {
        viewByCategoryButton.selected = YES;
        viewByMonthButton.selected = NO;
        
        overviewByCategory.view.hidden = NO;
        overviewByMonth.view.hidden = YES;
        [overviewByCategory reload];
    }
}

- (void)onPickYear {
    if (!self.fullScreenController) {
        self.fullScreenController = (FullScreenViewController*)[FullScreenViewController instanceFromNib];
        self.fullScreenController.delegate = self;
    }

    [self.yearPicker reloadAllComponents];
    int selectedIndex = [self.availableYears indexOfObject:self.currentYear];
    [self.yearPicker selectRow:selectedIndex inComponent:0 animated:NO];
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
    return self.availableYears.count;
}

#pragma mark - year pickder view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return formatYearString([self.availableYears objectAtIndex:row]);
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentYear = [self.availableYears objectAtIndex:row];
    [self reloadAll];
}

#pragma mark - report view delegate

- (void)pickedDate:(NSDate *)day {
    MonthViewRoot* monthView = (MonthViewRoot*)[MonthViewRoot instanceFromNib];
    [monthView setStartDate:firstDayOfMonth(day) endDate:lastDayOfMonth(day)];
    [self.navigationController pushViewController:monthView animated:YES];
}

- (void)pickedCategory:(int)categoryId {
    SingleCategoryByYearView* categoryView = (SingleCategoryByYearView*)[SingleCategoryByYearView instanceFromNib];
    NSMutableDictionary* options = [NSMutableDictionary dictionary];
    [options setObject:firstDayOfMonth(firstMonthOfYear(self.currentYear)) forKey:@"startDate"];
    [options setObject:lastDayOfMonth(lastMonthOfYear(self.currentYear)) forKey:@"endDate"];
    [options setObject:[NSNumber numberWithInt:categoryId] forKey:@"categoryId"];
    [categoryView setViewOptions:options];
    [self.navigationController pushViewController:categoryView animated:YES];
}

@end
