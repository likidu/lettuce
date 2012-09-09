//
//  SingleCategoryByMonthView.m
//  woojuu
//
//  Created by Lee Rome on 12-7-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleCategoryByMonthView.h"
#import "Statistics.h"
#import "CategoryManager.h"
#import "ExpenseManager.h"
#import "RootViewController.h"

@implementation SingleCategoryByMonthView

@synthesize cellTemplate;
@synthesize table;
@synthesize navigationItemView;

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize categoryId;
@synthesize expenses;

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

    self.navigationItem.titleView = self.navigationItemView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell*)loadCell {
    static NSString* cellId = @"CategoryExpenseCell";
    UITableViewCell* cell = [self.table dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        [[NSBundle mainBundle]loadNibNamed:@"ExpenseCellWithDateNoIcon" owner:self options:nil];
        cell = self.cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
    [self refreshUi];
}

- (void)refreshUi {
    // set current category
    Category* cat = [CategoryManager categoryById:self.categoryId];
    self.navigationItem.title = cat.categoryName;
    self.navigationItemView.text = cat.categoryName;
    
    [self.table reloadData];    
    
}
#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self loadCell];
    if (cell) {
        Expense* exp = [self.expenses objectAtIndex:indexPath.row];
        UILabel* dateLabel = (UILabel*)[cell viewWithTag:kCellDate];
        dateLabel.text = formatMonthDayString(exp.date);
        
        UILabel* textLabel = (UILabel*)[cell viewWithTag:kCellCategoryText];
        textLabel.text = (exp.notes && exp.notes.length > 0) ? exp.notes : [CategoryManager categoryNameById:self.categoryId];
        
        UIImageView* photoIcon = (UIImageView*)[cell viewWithTag:kCellPhotoIcon];
        photoIcon.hidden = (!exp.pictureRef || exp.pictureRef.length == 0);
        
        UILabel* amountLabel = (UILabel*)[cell viewWithTag:kCellAmount];
        amountLabel.text = formatAmount(exp.amount, NO);
    }
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // goto the transaction dialog to edit the selected item
    Expense* expense = (Expense*)[self.expenses objectAtIndex:indexPath.row];
    UIApplication* app = [UIApplication sharedApplication];
    RootViewController* rootView = (RootViewController*)app.keyWindow.rootViewController;
    [rootView presentAddTransactionDialog:expense];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* label = (UILabel*)[cell viewWithTag:kCellAmount];
    label.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* label = (UILabel*)[cell viewWithTag:kCellAmount];
    label.hidden = NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete expense record from database
        Expense* exp = [self.expenses objectAtIndex:indexPath.row];
        [[ExpenseManager instance]deleteExpenseById:exp.expenseId];
        [self.expenses removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - view option responder

- (void)setViewOptions:(NSDictionary *)options {
    if ([options objectForKey:@"startDate"]) self.startDate = (NSDate*)[options objectForKey:@"startDate"];
    if ([options objectForKey:@"endDate"]) self.endDate = (NSDate*)[options objectForKey:@"endDate"];
    if ([options objectForKey:@"categoryId"]) self.categoryId = [[options objectForKey:@"categoryId"]intValue];
    
    [self refresh];    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)refresh {
    self.expenses = [NSMutableArray arrayWithArray:[Statistics getExpensesOfCategory:self.categoryId fromDate:self.startDate toDate:self.endDate]];
}

@end
