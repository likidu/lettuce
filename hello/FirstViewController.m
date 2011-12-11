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
#import "RootViewController.h"

@implementation FirstViewController

@synthesize budgetLabel;
@synthesize cellTemplate;
@synthesize dateLabel;
@synthesize balanceLabel;
@synthesize savingLabel;
@synthesize transactionTable;
@synthesize stampView;
@synthesize progressView;
@synthesize todayExpenses;

static NSString* cellId = @"cellTransaction";
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (viewInitialized)
        return;
    viewInitialized = YES;
    
    budgetView = [BudgetView instance];
    settingView = [[SettingView alloc]initWithNibName:@"SettingView" bundle:[NSBundle mainBundle]];    
}

- (void)loadCellFromNib {
    if (cellTemplate != nil)
        return;
    
    [[NSBundle mainBundle] loadNibNamed:@"ExpenseCell" owner:self options:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    budgetLabel.text = formatAmount(balance, NO);
    if (balance < 0)
        budgetLabel.textColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0];
    else
        budgetLabel.textColor = [UIColor darkTextColor];
    double balanceOfMonth = [Statistics getBalanceOfMonth];
    balanceLabel.text = formatAmount(balanceOfMonth, NO);
    double savingOfMonth = [Statistics getSavingOfMonth:today];
    savingLabel.text = formatAmount(savingOfMonth, NO);
    stampView.hidden = balance > 0;
    
    // update saving progress
    double totalBudgetOfMonth = [[BudgetManager instance]getTotalBudgetOfMonth:today];
    CGRect frame = progressView.frame;
    frame.size.width = 320 * savingOfMonth / totalBudgetOfMonth;
    progressView.frame = frame;
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
    viewInitialized = NO;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.budgetLabel = nil;
    self.cellTemplate = nil;
    self.dateLabel = nil;
    self.balanceLabel = nil;
    self.savingLabel = nil;
    self.transactionTable = nil;
    self.stampView = nil;
    self.progressView = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        [self loadCellFromNib];
        cell = cellTemplate;
        self.cellTemplate = nil;
    }
    UIImageView *catImage = (UIImageView*)[cell viewWithTag:1];
    UILabel *catName = (UILabel*)[cell viewWithTag:2];
    UILabel *catAmount = (UILabel*)[cell viewWithTag:3];
    UIImageView * tagImage = (UIImageView*)[cell viewWithTag:4];
    if (catImage == nil || catName == nil || catAmount == nil || tagImage == nil)
        return nil;
    
    CategoryManager *catMan = [CategoryManager instance];
    
    if (indexPath.row < todayExpenses.count) {
        Expense* expense = [todayExpenses objectAtIndex:indexPath.row];
        Category* cat = [catMan.categoryDictionary objectForKey: [NSNumber numberWithInt:expense.categoryId]];
        BOOL showNotes = (expense.notes != nil) && (expense.notes.length > 0);
        if (showNotes)
            catName.text = expense.notes;
        else
            catName.text = cat.categoryName;
        catAmount.text = [NSString stringWithFormat:@"¥ %.2f", expense.amount];
        catImage.image = [catMan iconNamed:cat.smallIconName];
        BOOL hasImageNote = expense.pictureRef && expense.pictureRef.length > 0;
        tagImage.hidden = !hasImageNote;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return todayExpenses.count;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Expense* expense = [todayExpenses objectAtIndex:indexPath.row];
    UIApplication* app = [UIApplication sharedApplication];
    RootViewController* rootView = (RootViewController*)app.keyWindow.rootViewController;
    [rootView presentAddTransactionDialog:expense];
}

- (void)onChangeBudget:(id)sender {
    [[self rootViewController]presentModalViewController:budgetView animated:YES];
}

- (void)onSettings:(id)sender {
    [[self rootViewController]presentModalViewController:settingView animated:YES];
}

- (void)dealloc
{
    [super dealloc];
    [budgetView release];
    [settingView release];
    self.todayExpenses = nil;

    self.budgetLabel = nil;
    self.cellTemplate = nil;
    self.dateLabel = nil;
    self.balanceLabel = nil;
    self.savingLabel = nil;
    self.transactionTable = nil;
    self.stampView = nil;
    self.progressView = nil;
}

@end
