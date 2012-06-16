//
//  TodayViewController.m
//  woojuu
//
//  Created by Lee Rome on 11-12-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TodayViewController.h"
#import "ExpenseManager.h"
#import "CategoryManager.h"
#import "Statistics.h"
#import "PlanManager.h"

@implementation TodayViewController

@synthesize progressView;
@synthesize monthlyBudgetLabel;
@synthesize monthlyExpenseLabel;
@synthesize monthlyBalanceLabel;
@synthesize todayExpenseLabel;
@synthesize expenseTable;
@synthesize cellTemplate;
@synthesize dateLabel;
@synthesize settingView;

@synthesize expenses;

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

    NSMutableDictionary* theme = [[[NSMutableDictionary alloc]init]autorelease];
    UIImage* flagImage = [UIImage imageNamed:@"img.flag.png"];
    UIImage* slotImage = [UIImage imageNamed:@"img.slot.png"];
    UIImage* image = [UIImage imageNamed:@"img.bar.start.darkred.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.darkred.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.darkred.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [theme setObject:slotImage forKey:@"img.slot"];
    [progressView registerTheme:theme withName:@"darkred"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.green.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.green.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.green.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [theme setObject:slotImage forKey:@"img.slot"];
    [progressView registerTheme:theme withName:@"green"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.red.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.red.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.red.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [theme setObject:slotImage forKey:@"img.slot"];
    [progressView registerTheme:theme withName:@"red"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.orange.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.orange.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.orange.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [theme setObject:slotImage forKey:@"img.slot"];
    [progressView registerTheme:theme withName:@"orange"];

    progressView.activeThemeName = @"green";
    progressView.progress = 0.0;
    progressView.flagProgress = 0.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.monthlyBudgetLabel = nil;
    self.monthlyExpenseLabel = nil;
    self.monthlyBalanceLabel = nil;
    self.todayExpenseLabel = nil;
    self.expenseTable = nil;
    self.dateLabel = nil;
    self.settingView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - view controller events

- (void)viewWillAppear:(BOOL)animated {
    NSDate* today = [NSDate date];
    ExpenseManager* expMan = [ExpenseManager instance];
    self.expenses = [expMan loadExpensesOfDay:today orderBy:@"ExpenseId" ascending:false];
    [expenseTable reloadData];
    
    double expenseOfToday = [Statistics getTotalOfDay:today];
    todayExpenseLabel.text = formatAmount(expenseOfToday, NO);
    
    double budgetOfMonth = [PlanManager getBudgetOfMonth:today];
    monthlyBudgetLabel.text = formatAmount(budgetOfMonth, NO);
    
    double expenseOfMonth = [Statistics getTotalOfMonth:today];
    monthlyExpenseLabel.text = formatAmount(expenseOfMonth, NO);
    
    double balanceOfMonth = [Statistics getBalanceOfMonth:today];
    monthlyBalanceLabel.text = formatAmount(balanceOfMonth, NO);
    
    double dayOfMonth = getDay(today);
    double daysOfMonth = getDayAmountOfMonth(today);
    progressView.flagProgress = dayOfMonth / daysOfMonth;
    
    NSString* themeName = @"green";
    if (balanceOfMonth <= 0.0)
        themeName = @"darkred";
    else {
        double dailyBudget = budgetOfMonth / daysOfMonth;
        double daysOfOverSpend = (expenseOfMonth - dailyBudget * dayOfMonth) / dailyBudget;
        if (daysOfOverSpend >= 3.0)
            themeName = @"red";
        else if (daysOfOverSpend > 0)
            themeName = @"orange";
    }
    progressView.activeThemeName = themeName;
    
    dateLabel.text = formatDisplayDate(today);
}

- (void)viewDidAppear:(BOOL)animated {
    NSDate* today = [NSDate date];
    double expenseOfMonth = [Statistics getTotalOfMonth:today];
    double budgetOfMonth = [PlanManager getBudgetOfMonth:today];
    [progressView setProgress:(expenseOfMonth/budgetOfMonth) animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [progressView setProgress:0.0 animated:NO];
}

#pragma mark - table view data source

static NSString* cellId = @"expenseCell";

- (void)loadCellFromNib {
    if (cellTemplate)
        return;
    
    [[NSBundle mainBundle]loadNibNamed:@"ExpenseCell" owner:self options:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (!cell) {
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
    
    if (indexPath.row < expenses.count) {
        Expense* expense = [expenses objectAtIndex:indexPath.row];
        Category* cat = [catMan.categoryDictionary objectForKey: [NSNumber numberWithInt:expense.categoryId]];
        BOOL showNotes = (expense.notes != nil) && (expense.notes.length > 0);
        if (showNotes)
            catName.text = expense.notes;
        else
            catName.text = cat.categoryName;
        catAmount.text = formatAmount(expense.amount, YES);
        catImage.image = [catMan iconNamed:cat.smallIconName];
        BOOL hasImageNote = expense.pictureRef && expense.pictureRef.length > 0;
        tagImage.hidden = !hasImageNote;
    }
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - show settings

-(void)onSetting {
    [[self rootViewController]presentModalViewController:self.settingView animated:YES];
}

@end
