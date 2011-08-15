//
//  SavingHistoryViewController.m
//  woojuu
//
//  Created by Rome Lee on 11-8-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SavingHistoryViewController.h"
#import "BudgetManager.h"
#import "ExpenseManager.h"

@implementation SavingHistoryViewController

@synthesize table;
@synthesize dates;
@synthesize budgets;
@synthesize totals;
@synthesize startDate;
@synthesize endDate;
@synthesize cellTemplate;
@synthesize tableUpdateDelegate;

+ (SavingHistoryViewController *)createInstance {
    SavingHistoryViewController* t = [[[SavingHistoryViewController alloc]initWithNibName:@"SavingHistoryViewController" bundle:[NSBundle mainBundle]]autorelease];
    return t;
}

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.startDate = start;
    self.endDate = end;
    NSDate* firstDay = [ExpenseManager firstDayOfExpense];
    NSDate* today = normalizeDate([NSDate date]);
    if (firstDay == nil)
        firstDay = today;
    firstDay = maxDay(firstDay, startDate);
    NSDate* lastDay = minDay(endDate, today);
    self.startDate = firstDay;
    self.endDate = lastDay;
    [self reload];
}

- (void)reload {
    self.dates = getDatesBetween(startDate, endDate);
    self.dates = [[dates reverseObjectEnumerator]allObjects];
    NSMutableArray* b = [NSMutableArray arrayWithCapacity:dates.count];
    for (NSDate* date in dates) {
        double value = [[BudgetManager instance]getBudgetOfDay:date];
        [b addObject:[NSNumber numberWithDouble:value]];
    }
    self.budgets = b;
    self.totals = [[ExpenseManager instance]loadTotalBetweenStartDate:startDate endDate:endDate];
    
    [table reloadData];
}

- (BOOL)canEdit {
    return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // scroll to today
    NSDate* today = [NSDate date];
    int index = -1;
    for (int i = 0; i < dates.count; ++i) {
        if (isSameDay([dates objectAtIndex:i], today)) {
            index = i;
            break;
        }
    }
    if (index == -1)
        return;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dates.count;
}

- (UITableViewCell*)loadSavingCell {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (!cellTemplate) {
            [[NSBundle mainBundle]loadNibNamed:@"SavingCell" owner:self options:nil];
        }
        cell = cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self loadSavingCell];
    // Configure the cell...
    NSDate* date = [dates objectAtIndex:indexPath.row];
    UILabel* dateLabel = (UILabel*)[cell viewWithTag:kSavingDate];
    dateLabel.text = formatMonthDayString(date);
    UILabel* totalLabel = (UILabel*)[cell viewWithTag:kSavingExpense];
    NSNumber* totalNumber = [totals objectForKey:DATESTR(date)];
    double total = totalNumber? [totalNumber doubleValue] : 0.0;
    totalLabel.text = formatAmount(total, NO);
    double budget = [[budgets objectAtIndex:indexPath.row]doubleValue];
    UILabel* balanceLabel = (UILabel*)[cell viewWithTag:kSavingBalance];
    double balance = budget - total;
    if (balance < 0)
        balance = 0.0;
    balanceLabel.text = formatAmount(balance, NO);
    UILabel* budgetLabel = (UILabel*)[cell viewWithTag:kSavingBudget];
    budgetLabel.text = formatAmount(budget, NO);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableUpdateDelegate navigateTo:kExpense withData:[dates objectAtIndex:indexPath.row]];
}

@end
