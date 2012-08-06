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
#import "ExpenseHistoryViewController.h"
#import "SavingHistoryViewController.h"
#import "ExpenseHistoryByAmountViewController.h"
#import "ExpenseHistoryByCategoryViewController.h"
#import "ExpenseHistoryByLocationViewController.h"

#import "HistoryViewFrame.h"

@implementation SecondViewController

@synthesize months;
@synthesize currentMonth;
@synthesize monthPicker;
@synthesize monthPickerPlaceholder;
@synthesize filterButton;
@synthesize editButton;
@synthesize tablePlaceholder;
@synthesize switchButtonSaving;
@synthesize switchButtonExpense;
@synthesize switchPlaceholder;
@synthesize monthButton;
@synthesize byAmountButton;
@synthesize byCategoryButton;
@synthesize byLocationButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tables_ = [[NSMutableArray alloc]initWithCapacity:4];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (viewInitialized)
        return;
    viewInitialized = YES;
    
    activeSwitch = kExpenseSaving;
    
    // create tables
    // expense table
    ExpenseHistoryViewController* table = (ExpenseHistoryViewController*)[ExpenseHistoryViewController instanceFromNib];
    table.tableUpdateDelegate = self;
    table.view.frame = tablePlaceholder.frame;
    [self.view addSubview:table.view];
    [self.view bringSubviewToFront:table.view];
    [tables_ addObject:table];
    // saving table
    SavingHistoryViewController* savingTable = (SavingHistoryViewController*)[SavingHistoryViewController instanceFromNib];
    savingTable.tableUpdateDelegate = self;
    savingTable.view.frame = tablePlaceholder.frame;
    [self.view addSubview:savingTable.view];
    [self.view bringSubviewToFront:savingTable.view];
    savingTable.view.hidden = YES;
    [tables_ addObject:savingTable];
    // by amount table
    ExpenseHistoryByAmountViewController* byAmountTable = (ExpenseHistoryByAmountViewController*)[ExpenseHistoryByAmountViewController instanceFromNib];
    byAmountTable.tableUpdateDelegate = self;
    byAmountTable.view.frame = tablePlaceholder.frame;
    [self.view addSubview:byAmountTable.view];
    [self.view bringSubviewToFront:byAmountTable.view];
    byAmountTable.view.hidden = YES;
    [tables_ addObject:byAmountTable];
    // by category table
    ExpenseHistoryByCategoryViewController* byCategoryTable = (ExpenseHistoryByCategoryViewController*)[ExpenseHistoryByCategoryViewController instanceFromNib];
    byCategoryTable.tableUpdateDelegate = self;
    byCategoryTable.view.frame = tablePlaceholder.frame;
    [self.view addSubview:byCategoryTable.view];
    [self.view bringSubviewToFront:byCategoryTable.view];
    byCategoryTable.view.hidden = YES;
    [tables_ addObject:byCategoryTable];
    // by location view
    ExpenseHistoryByLocationViewController* byLocationView = (ExpenseHistoryByLocationViewController*)[ExpenseHistoryByLocationViewController instanceFromNib];
    byLocationView.view.frame = tablePlaceholder.frame;
    [self.view addSubview:byLocationView.view];
    [self.view bringSubviewToFront:byLocationView.view];
    byLocationView.view.hidden = YES;
    [tables_ addObject:byLocationView];
    
    // set active table
    activeTable = kExpense;
    
    // create month picker
    self.monthPicker = [MonthPickerController pickerWithMonths:months];
    monthPicker.view.frame = monthPickerPlaceholder.frame;
    monthPicker.delegate = self;
    [monthPickerPlaceholder.superview addSubview:monthPicker.view];
    [monthPickerPlaceholder.superview bringSubviewToFront:monthPicker.view];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait;
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
    viewInitialized = NO;
    // Release any retained subviews of the main view.
    self.monthPickerPlaceholder = nil;
    self.filterButton = nil;
    self.editButton = nil;
    self.tablePlaceholder = nil;
    self.switchButtonExpense = nil;
    self.switchButtonSaving = nil;
    self.switchPlaceholder = nil;
    self.monthButton = nil;
    self.byAmountButton = nil;
    self.byCategoryButton = nil;
    self.monthPicker = nil;
}

- (void)updateSwitchButtonData {
    double total = [Statistics getTotalOfMonth:currentMonth];
    double saving = [Statistics getSavingOfMonth:currentMonth];
    [switchButtonExpense setTitle:[NSString stringWithFormat:@"消费%@%.f", CURRENCY_CODE, total] forState:UIControlStateNormal];
    [switchButtonSaving setTitle:[NSString stringWithFormat:@"已省%@%.f", CURRENCY_CODE, saving] forState:UIControlStateNormal];
}

- (void)presentTable:(int)tableIndex {
    if (activeTable == tableIndex)
        return;
    UIViewController* oldTable = [tables_ objectAtIndex:activeTable];
    UIViewController* newTable = [tables_ objectAtIndex:tableIndex];
    if (!oldTable || !newTable)
        return;
    // update data for new table
    id<DateRangeResponder> responder = (UIViewController<DateRangeResponder>*)newTable;
    [responder setStartDate:firstDayOfMonth(currentMonth) endDate:lastDayOfMonth(currentMonth)];
    // show/hide the editing button
    if ([responder canEdit]) {
        editButton.hidden = NO;
        editButton.selected = NO;
        [responder setEditing:NO];
    }
    else
        editButton.hidden = YES;
    // adjust size
    newTable.view.frame = tablePlaceholder.frame;
    // present view
    [CATransaction begin];
    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.2;
    oldTable.view.hidden = YES;
    [oldTable.view.layer addAnimation:animation forKey:@""];
    [CATransaction commit];
    
    [CATransaction begin];
    animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.2;
    newTable.view.hidden = NO;
    [newTable.view.layer addAnimation:animation forKey:@""];
    [CATransaction commit];
    
    activeTable = tableIndex;
}

- (void)onSwitchButtonSaving {
    switchButtonSaving.selected = YES;
    switchButtonExpense.selected = NO;
    [self presentTable:kSaving];
}

- (void)onSwitchButtonExpense {
    switchButtonExpense.selected = YES;
    switchButtonSaving.selected = NO;
    [self presentTable:kExpense];
}

- (void)onSwitchButtonByAmount {
    byAmountButton.selected = YES;
    byCategoryButton.selected = NO;
    byLocationButton.selected = NO;
    [self presentTable:kByAmount];
}

- (void)onSwitchButtonByCategory {
    byAmountButton.selected = NO;
    byCategoryButton.selected = YES;
    byLocationButton.selected = NO;
    [self presentTable:kByCategory];
}

- (void)onSwitchButtonByLocation {
    byAmountButton.selected = NO;
    byCategoryButton.selected = NO;
    byLocationButton.selected = YES;
    [self presentTable:kByLocation];
}

- (void)presentSwitchArea:(int)area {
    if (activeSwitch == area)
        area = kExpenseSaving;
    monthButton.selected = area == kMonthPicker;
    filterButton.selected = area == kFilter;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame = switchPlaceholder.frame;
                         frame.origin.x = -320 * (float)area;
                         switchPlaceholder.frame = frame;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             activeSwitch = area;
                             if (activeSwitch == kExpenseSaving) {
                                 if (switchButtonExpense.selected)
                                     [self presentTable:kExpense];
                                 else
                                     [self presentTable:kSaving];
                             }
                             else if (activeSwitch == kFilter) {
                                 if (byAmountButton.selected)
                                     [self presentTable:kByAmount];
                                 else if (byCategoryButton.selected)
                                     [self presentTable:kByCategory];
                                 else
                                     [self presentTable:kByLocation];
                             }
                         }
                     }];
}

- (void)navigateTo:(int)tableId withData:(NSObject *)data {
    if (tableId == kExpense || tableId == kSaving) {
        switchButtonExpense.selected = tableId == kExpense;
        switchButtonSaving.selected = tableId == kSaving;
        [self presentSwitchArea:kExpenseSaving];
    }
    else {
        byAmountButton.selected = tableId == kByAmount;
        byCategoryButton.selected = tableId == kByCategory;
        byLocationButton.selected = tableId == kByLocation;
        [self presentSwitchArea:kFilter];
    }
    
    // use data to navigate
    UIViewController* table = (UIViewController*)[tables_ objectAtIndex:tableId];
    id<DateRangeResponder> responder = (UIViewController<DateRangeResponder>*)table;
    [responder navigateToData:data];

}

- (void)dataChanged {
    [self updateSwitchButtonData];
}

- (void)onMonthButton{
    [self presentSwitchArea:kMonthPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    ExpenseManager* expMan = [ExpenseManager instance];
    
    // show the month list
    self.months = [expMan loadMonths];
    self.currentMonth = [months lastObject];
    self.monthPicker.months = self.months;
    [self.monthPicker reload];
    
    // load table data
    UIViewController* table = (UIViewController*)[tables_ objectAtIndex:activeTable];
    id<DateRangeResponder> responder = (UIViewController<DateRangeResponder>*)table;
    [responder setStartDate:firstDayOfMonth(currentMonth) endDate:lastDayOfMonth(currentMonth)];
    table.view.frame = tablePlaceholder.frame;
    
    // update switcher buttons
    [self updateSwitchButtonData];
}

- (void)updateMonthButtonTitle:(NSString*)title {
    [monthButton setTitle:title forState:UIControlStateNormal];
    makeDropButton(monthButton);
}

- (void)viewDidAppear:(BOOL)animated {
    [monthPicker pickMonth:currentMonth];
    [self updateMonthButtonTitle:formatMonthString(currentMonth)];
}

- (void)onEdit:(id)sender {
    // check whether the current table is editable
    UIViewController* table = (UIViewController*)[tables_ objectAtIndex:activeTable];
    if (![table conformsToProtocol:@protocol(DateRangeResponder)])
        return;
    id<DateRangeResponder> responder = (UIViewController<DateRangeResponder>*)table;
    UIButton* button = sender;
    if (!button)
        return;
    if (![responder canEdit]){
        button.selected = NO;
        return;
    }
    // toggle the editing status for normal case
    button.selected = !button.selected;
    [responder setEditing:button.selected];
}

- (void)onFilter {
    UIViewController* history = [[[HistoryViewFrame alloc]initWithNibName:@"HistoryViewFrame" bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:history animated:YES];
    return;
    [self presentSwitchArea:kFilter];
}

- (void)monthPicked:(NSDate *)dayOfMonth {
    if (isSameMonth(dayOfMonth, currentMonth))
        return;
    self.currentMonth = dayOfMonth;
    id<DateRangeResponder> responder = (UIViewController<DateRangeResponder>*)[tables_ objectAtIndex:activeTable];
    [responder setStartDate:firstDayOfMonth(currentMonth) endDate:lastDayOfMonth(currentMonth)];
    [self updateSwitchButtonData];
    [self updateMonthButtonTitle:formatMonthString(dayOfMonth)];
}

- (void)dealloc
{
    [super dealloc];
    CLEAN_RELEASE(tables_);
    self.months = nil;
    self.currentMonth = nil;
    
    self.monthPickerPlaceholder = nil;
    self.filterButton = nil;
    self.editButton = nil;
    self.tablePlaceholder = nil;
    self.switchButtonExpense = nil;
    self.switchButtonSaving = nil;
    self.switchPlaceholder = nil;
    self.monthButton = nil;
    self.byAmountButton = nil;
    self.byCategoryButton = nil;
    self.monthPicker = nil;
}

@end
