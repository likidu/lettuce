//
//  ExpenseHistoryByAmountViewController.m
//  woojuu
//
//  Created by Rome Lee on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ExpenseHistoryByAmountViewController.h"
#import "ExpenseManager.h"
#import "CategoryManager.h"
#import "MiddleViewController.h"

@implementation ExpenseHistoryByAmountViewController

@synthesize tableView;
@synthesize cellTemplate;
@synthesize startDate;
@synthesize endDate;
@synthesize expenses;
@synthesize tableUpdateDelegate;

#pragma mark - DateRangeResponder protocol

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.startDate = start;
    self.endDate = end;
    [self reload];
}

- (void)reload {
    self.expenses = [[ExpenseManager instance]getExpensesBetween:startDate endDate:endDate orderBy:@"amount" assending:NO];
    [self.tableView reloadData];
}

- (BOOL)canEdit {
    return NO;
}

- (void)dealloc
{
    self.startDate = nil;
    self.endDate = nil;
    self.expenses = nil;
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
    self.tableView = nil;
    self.cellTemplate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    return expenses.count;
}

- (UITableViewCell*)loadProperCell {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (!cellTemplate) {
            [[NSBundle mainBundle]loadNibNamed:@"ExpenseCellWithDate" owner:self options:nil];
        }
        cell = cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self loadProperCell];
    
    // cell data
    Expense* expense = [expenses objectAtIndex:indexPath.row];
    Category* cat = [CategoryManager categoryById:expense.categoryId];
    // category icon
    UIImageView* catImage = (UIImageView*)[cell viewWithTag:kCellCategoryIcon];
    catImage.image = [[CategoryManager instance]iconNamed:cat.smallIconName];
    // category text
    UILabel* catName = (UILabel*)[cell viewWithTag:kCellCategoryText];
    if (expense.notes && expense.notes.length > 0)
        catName.text = expense.notes;
    else
        catName.text = cat.categoryName;
    // amount
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:kCellAmount];
    amountLabel.text = formatAmount(expense.amount, YES);
    // photo icon
    UIImageView* photoIcon = (UIImageView*)[cell viewWithTag:kCellPhotoIcon];
    photoIcon.hidden = (!expense.pictureRef || expense.pictureRef.length == 0);
    // date label
    UILabel* dateLabel = (UILabel*)[cell viewWithTag:kCellDate];
    dateLabel.text = formatMonthDayString(expense.date);
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    Expense* expense = [expenses objectAtIndex:indexPath.row];
    [MiddleViewController showAddTransactionView:expense];
}

@end
