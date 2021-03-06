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
#import "MiddleViewController.h"
#import "UIColor+Helper.h"

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

@synthesize todayExpensePanel;
@synthesize recentStatsPanel;
@synthesize recentStatsTable;
@synthesize daysSinceFirstUse;
@synthesize rewardStamp;
@synthesize ordinaryStamp;
@synthesize stampMask;
@synthesize topLine;
@synthesize midLine;
@synthesize arrowImage;
@synthesize darkRedColor;

@synthesize expenses;
@synthesize recentExpenseStats;

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
    
    self.darkRedColor = [UIColor colorWithRed:0.435 green:0.043 blue:0.0 alpha:1.0]; 
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
    self.darkRedColor = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - view controller events

- (void)setDaysSinceUseLabel:(NSString*)text {
    if (self.daysSinceFirstUse)
        [self.daysSinceFirstUse removeFromSuperview];

    self.daysSinceFirstUse = [[UILabel alloc]initWithFrame:self.ordinaryStamp.frame];
    self.daysSinceFirstUse.textAlignment = UITextAlignmentCenter;
    self.daysSinceFirstUse.textColor = [UIColor colorWithRed:0.83 green:0.83 blue:0.83 alpha:1.0];
    self.daysSinceFirstUse.font = [UIFont boldSystemFontOfSize:80];
    self.daysSinceFirstUse.text = text;
    self.daysSinceFirstUse.backgroundColor = [UIColor clearColor];
    self.daysSinceFirstUse.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [self.recentStatsPanel addSubview:self.daysSinceFirstUse];
    [self.recentStatsPanel sendSubviewToBack:self.daysSinceFirstUse];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateData];    
    [self updateUi];
    [expenseTable reloadData];
    [recentStatsTable reloadData];
}

- (void)updateData {
    NSDate* today = [NSDate date];
    ExpenseManager* expMan = [ExpenseManager instance];
    self.expenses = [expMan loadExpensesOfDay:today orderBy:@"ExpenseId" ascending:false];
    
    self.recentExpenseStats = [Statistics getExpenseStatsOfRecent30Days];
}

- (void)updateUi {
    NSDate* today = normalizeDate([NSDate date]);
    double expenseOfToday = [Statistics getTotalOfDay:today];
    todayExpenseLabel.text = formatAmount(expenseOfToday, NO);
    
    double budgetOfMonth = [PlanManager getBudgetOfMonth:today];
    monthlyBudgetLabel.text = formatAmount(budgetOfMonth, NO);
    
    double expenseOfMonth = [Statistics getTotalOfMonth:today];
    monthlyExpenseLabel.text = formatAmount(expenseOfMonth, NO);
    
    double balanceOfMonth = [Statistics getBalanceOfMonth:today];
    monthlyBalanceLabel.text = formatAmount(balanceOfMonth, NO);
    if (balanceOfMonth < 0)
        monthlyBalanceLabel.textColor = self.darkRedColor;
    else
        monthlyBalanceLabel.textColor = [UIColor blackColor];
    
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

    self.todayExpensePanel.hidden = self.expenses.count <= 0 && self.recentExpenseStats.count > 0;
    self.recentStatsPanel.hidden = self.expenses.count > 0 || self.recentExpenseStats.count == 0;
    
    NSDate* firstActionDay = normalizeDate([Statistics getFirstDayOfUserAction]);
    int daysSinceFirstDay = [today timeIntervalSinceDate:firstActionDay] / TIME_INTERVAL_DAY;
    NSLog(@"%d days", daysSinceFirstDay);
    [self setDaysSinceUseLabel:[NSString stringWithFormat:@"%d", daysSinceFirstDay]];
    
    if (daysSinceFirstDay < 21) {
        self.topLine.hidden = NO;
        self.recentStatsTable.hidden = NO;
        self.rewardStamp.hidden = YES;
        self.ordinaryStamp.hidden = NO;
        self.daysSinceFirstUse.hidden = NO;
        self.stampMask.hidden = NO;
        self.midLine.hidden = YES;
        self.arrowImage.hidden = YES;
    }
    else if (daysSinceFirstDay == 21) {
        self.midLine.text = @"你知道吗？养成一个习惯一般需要21天。恭喜你有了个新习惯！";
        self.topLine.hidden = YES;
        self.recentStatsTable.hidden = YES;
        self.rewardStamp.hidden = YES;
        self.ordinaryStamp.hidden = NO;
        self.daysSinceFirstUse.hidden = NO;
        self.stampMask.hidden = NO;
        self.midLine.hidden = NO;
        self.arrowImage.hidden = YES;
    }
    else if (daysSinceFirstDay == 50) {
        self.midLine.text = @"你知道吗？85%的人都无法坚持连续记账50天 :)";
        self.topLine.hidden = YES;
        self.recentStatsTable.hidden = YES;
        self.rewardStamp.hidden = YES;
        self.ordinaryStamp.hidden = NO;
        self.daysSinceFirstUse.hidden = NO;
        self.stampMask.hidden = NO;
        self.midLine.hidden = NO;
        self.arrowImage.hidden = YES;
    }
    else if (daysSinceFirstDay == 100) {
        self.midLine.text = @"你知道吗？";
        self.topLine.hidden = YES;
        self.recentStatsTable.hidden = YES;
        self.rewardStamp.hidden = NO;
        self.ordinaryStamp.hidden = YES;
        self.daysSinceFirstUse.hidden = YES;
        self.stampMask.hidden = NO;
        self.midLine.hidden = NO;
        self.arrowImage.hidden = NO;
    }
    else {
        self.topLine.hidden = NO;
        self.recentStatsTable.hidden = NO;
        self.rewardStamp.hidden = YES;
        self.ordinaryStamp.hidden = YES;
        self.daysSinceFirstUse.hidden = YES;
        self.stampMask.hidden = YES;
        self.midLine.hidden = YES;
        self.arrowImage.hidden = YES;
    }
}

- (void)updateProgress {
    NSDate* today = [NSDate date];
    double expenseOfMonth = [Statistics getTotalOfMonth:today];
    double budgetOfMonth = [PlanManager getBudgetOfMonth:today];
    [progressView setProgress:(expenseOfMonth/budgetOfMonth) animated:YES];    
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateProgress];
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
    if (tableView == self.recentStatsTable)
        return self.recentExpenseStats.count > 3 ? 3 : self.recentExpenseStats.count;
    return expenses.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.recentStatsTable)
        return NO;
    return YES;
}

- (UITableViewCell*)recentStatsCellAtIndexPath:(NSIndexPath*)indexPath {
    static NSString* statCellId = @"todayExpenseCategoryCell";
    
    if (indexPath.row >= self.recentExpenseStats.count)
        return nil;

    NSDictionary* stats = [self.recentExpenseStats objectAtIndex:indexPath.row];
    int categoryId = [[stats objectForKey:@"CategoryId"]intValue];
    double totalExpense = [[stats objectForKey:@"TotalExpense"]doubleValue];
    
    CategoryManager* catMan = [CategoryManager instance];
    Category* cat = [CategoryManager categoryById:categoryId];
    
    UITableViewCell* cell = [self.recentStatsTable dequeueReusableCellWithIdentifier:statCellId];
    if (!cell) {
        [[NSBundle mainBundle]loadNibNamed:@"TopExpenseCatetoryCell" owner:self options:nil];
        cell = self.cellTemplate;
        self.cellTemplate = nil;
    }
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:1];
    UITextView* categoryNameView = (UITextView*)[cell viewWithTag:2];
    UITextView* amountView = (UITextView*)[cell viewWithTag:3];
    imageView.image = [catMan iconNamed:cat.categoryIconName];
    categoryNameView.text = cat.categoryName;
    amountView.text = formatAmount(totalExpense, NO);
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.recentStatsTable)
        return [self recentStatsCellAtIndexPath:indexPath];
    
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
        catAmount.hidden = NO;
        catImage.image = [catMan iconNamed:cat.smallIconName];
        BOOL hasImageNote = expense.pictureRef && expense.pictureRef.length > 0;
        tagImage.hidden = !hasImageNote;
    }
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Expense* exp = [self.expenses objectAtIndex:indexPath.row];
    [MiddleViewController showAddTransactionView:exp];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Expense* exp = [self.expenses objectAtIndex:indexPath.row];
    [[ExpenseManager instance]deleteExpenseById:exp.expenseId];
    [self updateData];
    [self updateUi];
    [self updateProgress];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.expenses.count == 0)
        [self viewWillAppear:NO];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.expenseTable) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        UIView* amountView = [cell viewWithTag:3];
        amountView.hidden = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.expenseTable) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        UIView* amountView = [cell viewWithTag:3];
        amountView.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor slateColor];
    cell.selectedBackgroundView = bgColorView;
    [bgColorView release];
}

#pragma mark - show settings

-(void)onSetting {
    [[UIViewController topViewController]presentViewController:self.settingView animated:YES completion:nil];
}

@end
