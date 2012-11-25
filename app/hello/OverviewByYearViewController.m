//
//  OverviewByYearViewController.m
//  woojuu
//
//  Created by Lee Rome on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OverviewByYearViewController.h"
#import "Statistics.h"
#import "PlanManager.h"
#import "ExpenseManager.h"

@interface OverviewByYearViewController()

@property(nonatomic,retain) Dimmer* dimmer;

@end

@implementation OverviewByYearViewController

@synthesize tableView;
@synthesize dayOfYear;
@synthesize yearData;
@synthesize cellTemplate;
@synthesize delegate;

@synthesize budgetData;
@synthesize expenseData;
@synthesize balanceData;

@synthesize totalBalanceLabel;
@synthesize totalBudgetLabel;
@synthesize totalExpenseLabel;
@synthesize summaryView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dayOfYear = [NSDate date];
    self.tableView.scrollsToTop = YES;
    self.dimmer = [Dimmer dimmerWithView:self.summaryView];
    [self reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tableView = nil;
    self.dayOfYear = nil;
    self.yearData = nil;
    self.cellTemplate = nil;
    self.budgetData = nil;
    self.expenseData = nil;
    self.balanceData = nil;
    self.dimmer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self reload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell*)loadCell {
    
    static NSString *CellIdentifier = @"OverviewByYearCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (!cellTemplate) {
            [[NSBundle mainBundle]loadNibNamed:@"OverviewByYearCell" owner:self options:nil];
        }
        cell = cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (yearData)
        return yearData.count;
    else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self loadCell];
    
    // set month text
    UILabel* monthLabel = (UILabel*)[cell viewWithTag: kCellDate];
    NSString* titleText = formatMonthOnlyString([yearData objectAtIndex: indexPath.row]);
    monthLabel.text = titleText;
    // budget
    UILabel* budgetLabel = (UILabel*)[cell viewWithTag: kCellAmount];
    budgetLabel.text = formatAmount([[budgetData objectAtIndex:indexPath.row]doubleValue], NO);
    // expense
    UILabel* expenseLabel = (UILabel*)[cell viewWithTag: kCellAmount2];
    expenseLabel.text = formatAmount([[expenseData objectAtIndex:indexPath.row]doubleValue], NO);
    // balance
    UILabel* balanceLabel = (UILabel*)[cell viewWithTag: kCellAmount3];
    balanceLabel.text = formatAmount([[balanceData objectAtIndex:indexPath.row]doubleValue], NO);
    return cell;    
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [view deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(pickedDate:)]) {
        NSDate* dayOfMonth = [self.yearData objectAtIndex:indexPath.row];
        [self.delegate pickedDate:dayOfMonth];
    }
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.dimmer hide];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.dimmer show];
}

#pragma mark - date range responder

- (void)reload {
    self.yearData = [[Statistics getMonthsOfYear:self.dayOfYear]reverse];
    NSMutableArray* budgets = [NSMutableArray arrayWithCapacity:self.yearData.count];
    NSMutableArray* expenses = [NSMutableArray arrayWithCapacity:self.yearData.count];
    NSMutableArray* balances = [NSMutableArray arrayWithCapacity:self.yearData.count];
    double totalBudget = 0, totalExpense = 0, totalBalance = 0;
    for (int i = 0; i < self.yearData.count; i++) {
        NSDate* dayOfMonth = [self.yearData objectAtIndex:i];
        double budget = [PlanManager getBudgetOfMonth: dayOfMonth];
        [budgets addObject: [NSNumber numberWithDouble:budget]];
        totalBudget += budget;
        double expense = [Statistics getTotalOfMonth:dayOfMonth];
        [expenses addObject:[NSNumber numberWithDouble:expense]];
        totalExpense += expense;
        double balance = [Statistics getBalanceOfMonth:dayOfMonth];
        [balances addObject:[NSNumber numberWithDouble:balance]];
        totalBalance += balance;
    }
    
    self.budgetData = budgets;
    self.expenseData = expenses;
    self.balanceData = balances;
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    self.totalBudgetLabel.text = formatAmount(totalBudget, NO);
    self.totalExpenseLabel.text = formatAmount(totalExpense, NO);
    self.totalBalanceLabel.text = formatAmount(totalBalance, NO);
}

- (BOOL)canEdit {
    return NO;
}

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.dayOfYear = start;
    [self reload];
}

@end
