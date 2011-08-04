//
//  FirstViewController.m
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "CategoryManager.h"
#import "ExpenseManager.h"
#import "Database.h"
#import "BudgetManager.h"
#import "Statistics.h"


@implementation FirstViewController

@synthesize budgetLabel;
@synthesize transactionCell;
@synthesize transactionHeaderCell;
@synthesize transactionFooterCell;
@synthesize dateLabel;
@synthesize balanceLabel;
@synthesize savingLabel;
@synthesize transactionTable;
@synthesize stampView;

@synthesize todayExpenses;

static NSString* cellId = @"cellTransaction";
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    budgetView = [[BuddgetView alloc]initWithNibName:@"BuddgetView" bundle:[NSBundle mainBundle]];
    settingView = [[SettingView alloc]initWithNibName:@"SettingView" bundle:[NSBundle mainBundle]];
    newTransactionView = [[MiddleViewController alloc]initWithNibName:@"MiddleView" bundle:[NSBundle mainBundle]];
    
}

- (void)loadCellFromNib {
    if (transactionCell != nil)
        return;
    
    [[NSBundle mainBundle] loadNibNamed:@"CellTransaction" owner:self options:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onNewTransaction {
    [self presentModalViewController:newTransactionView animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSDate *today = [NSDate date];
    dateLabel.text = formatDisplayDate(today);
    
    ExpenseManager* expMan = [ExpenseManager instance];
    self.todayExpenses = [expMan loadExpensesOfDay:today orderBy:@"amount" ascending:NO];
    
    CategoryManager* catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase: NO];
    
    [transactionTable reloadData];
    
    // update budget label
    double balance = [Statistics getBalanceOfDay:today];
    budgetLabel.text = [NSString stringWithFormat:@"¥ %.f", balance];
    balanceLabel.text = [NSString stringWithFormat:@"¥ %.f", [Statistics getBalanceOfMonth:today]];
    savingLabel.text = [NSString stringWithFormat:@"¥ %.f", [Statistics getSavingOfMonth:today]];
    stampView.hidden = balance > 0;
}

- (void)viewDidAppear:(BOOL)animated {

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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        [self loadCellFromNib];
        cell = transactionCell;
        self.transactionCell = nil;
    }
    UIImageView *catImage = (UIImageView*)[cell viewWithTag:1];
    UILabel *catName = (UILabel*)[cell viewWithTag:2];
    UILabel *catAmount = (UILabel*)[cell viewWithTag:3];
    UIImageView * tagImage = (UIImageView*)[cell viewWithTag:4];
    if (catImage == nil || catName == nil || catAmount == nil || tagImage == nil)
        return nil;
    
    NSLog(@"Row index: %d", indexPath.row);
    
    CategoryManager *catMan = [CategoryManager instance];
    
    if (indexPath.row < todayExpenses.count) {
        Expense* expense = [todayExpenses objectAtIndex:indexPath.row];
        NSLog(@"catId: %d", expense.categoryId);
        Category* cat = [catMan.categoryDictionary objectForKey: [NSNumber numberWithInt:expense.categoryId]];
        BOOL showNotes = (expense.notes != nil) && (expense.notes.length > 0);
        if (showNotes)
            catName.text = expense.notes;
        else
            catName.text = cat.categoryName;
        catAmount.text = [NSString stringWithFormat:@"¥ %.2f", expense.amount];
        catImage.image = [catMan iconNamed:cat.smallIconName];
        BOOL hasImageNote = [[ExpenseManager instance]checkImageNoteByExpenseId:expense.expenseId];
        tagImage.hidden = !hasImageNote;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSLog(@"Expense count: %d", todayExpenses.count);
        return todayExpenses.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        [self loadCellFromNib];
        cell = transactionCell;
        self.transactionCell = nil;
    }
    return cell.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)onChangeBudget:(id)sender {
    [self presentModalViewController:budgetView animated:YES];
}

- (void)onSettings:(id)sender {
    [self presentModalViewController:settingView animated:YES];
}

- (void)dealloc
{
    [super dealloc];
    [budgetView release];
    [settingView release];
    [newTransactionView release];
}

@end
