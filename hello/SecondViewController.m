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
#import "DatePickerFullScreen.h"
#import "Database.h"

@implementation SecondViewController

@synthesize dates;
@synthesize transactionCache;
@synthesize transactionCell;
@synthesize transactionView;
@synthesize datePicker;
@synthesize headerView;
@synthesize footerView;
@synthesize uiDate;
@synthesize plotView;

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/
static NSString* cellId = @"cellTransaction";

- (void)loadCellFromNib {
    if (transactionCell != nil)
        return;
    
    [[NSBundle mainBundle] loadNibNamed:@"CellTransaction" owner:self options:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [plotView removeFromSuperview];
    }
    else {
        plotView.frame = self.view.frame;
        [self.view addSubview:plotView];
        [self.view bringSubviewToFront:plotView];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
    [self.transactionCache removeAllObjects];
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.transactionView = nil;
    self.transactionCell = nil;
    self.datePicker = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    ExpenseManager* expMan = [ExpenseManager instance];
    self.dates = [expMan loadExpenseDates];
    self.transactionCache = [NSMutableDictionary dictionary];
    [transactionView reloadData];
    transactionView.allowsSelection = NO;
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy年M月"];
    [uiDate setTitle:[formatter stringFromDate:[NSDate date]] forState:UIControlStateNormal];
}

- (void)forceLoadTransactionOfDateToCache:(NSDate*) day {
    ExpenseManager* expMan = [ExpenseManager instance];
    NSArray* array = [expMan loadExpensesOfDay:day orderBy:nil ascending:NO];
    [transactionCache setObject:array forKey:day];
}

- (void) loadTransactionOfDateToCache:(NSDate*) day {
    NSEnumerator *enumerator = [transactionCache keyEnumerator];
    id key; bool isFound = NO;
    while ((key = [enumerator nextObject])) {
        if (key == day) {
            isFound = YES;
            break;
        }
    }
    
    if (isFound)
        return;
    
    [self forceLoadTransactionOfDateToCache: day];
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
    UIImageView* tagImage = (UIImageView*)[cell viewWithTag:4];
    if (catImage == nil || catName == nil || catAmount == nil || tagImage == nil)
        return nil;
    
    NSDate* date = [dates objectAtIndex: indexPath.section];
    [self loadTransactionOfDateToCache:date];
    
    NSArray* expenses = [transactionCache objectForKey:date];
    CategoryManager *catMan = [CategoryManager instance];
    
    if (expenses && indexPath.row < expenses.count) {
        Expense* expense = [expenses objectAtIndex:indexPath.row];
        NSLog(@"catId: %d", expense.categoryId);
        Category* cat = [catMan.categoryDictionary objectForKey: [NSNumber numberWithInt:expense.categoryId]];
        BOOL showNotes = (expense.notes != nil) && (expense.notes.length > 0);
        if (showNotes)
            catName.text = expense.notes;
        else
            catName.text = cat.categoryName;
        catAmount.text = [NSString stringWithFormat:@"¥ %.2f", expense.amount];
        catImage.image = [catMan iconNamed:cat.iconName];
        UIImage* imageNote = [[ExpenseManager instance]getImageNoteIconByExpenseId: expense.expenseId];
        tagImage.hidden = !showNotes && !imageNote;
        if (imageNote)
            tagImage.image = imageNote;
        else
            tagImage.image = [[ExpenseManager instance]getDefaultTagImage];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < self.dates.count) {
        NSDate* date = [dates objectAtIndex:section];
        [self loadTransactionOfDateToCache:date];
        NSArray* array = [transactionCache objectForKey:date];
        return array.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dates count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [dateFormatter stringFromDate:[dates objectAtIndex:section]];
    return dateStr;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [[NSBundle mainBundle]loadNibNamed:@"HistoryTableViewHeader" owner:self options:nil];
    UIView* view = self.headerView;
    self.headerView = nil;
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    UILabel* label = (UILabel*)[view viewWithTag: 2];
    label.text = [dateFormatter stringFromDate:[dates objectAtIndex:section]];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    [[NSBundle mainBundle]loadNibNamed:@"HistoryTableViewFooter" owner:self options:nil];
    UIView* view = self.footerView;
    self.footerView = nil;
    UILabel* label = (UILabel*)[view viewWithTag: 2];
    UIImageView* stamp = (UIImageView*)[view viewWithTag: 3];
    if (section < dates.count) {
        ExpenseManager* expMan = [ExpenseManager instance];
        double balance = [expMan getBalanceOfDay:[dates objectAtIndex:section]];
        NSString* balanceStr;
        if (balance < 0.0)
            balanceStr = [NSString stringWithFormat:@"共超支 ¥ %.2f", -balance];
        else if (compareDate([dates objectAtIndex: section], [NSDate date]))
            balanceStr = [NSString stringWithFormat:@"预算还剩 ¥ %.2f", balance];
        else
            balanceStr = [NSString stringWithFormat:@"共节省 ¥ %.2f", balance];
        label.text = balanceStr;
        stamp.hidden = balance >= 0.0;
    }
    return view;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 35;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section < dates.count) {
        ExpenseManager* expMan = [ExpenseManager instance];
        double totalExpense = [expMan loadTotalOfDay:[dates objectAtIndex:section]];
        double balance = [expMan getBalanceOfDay:[dates objectAtIndex:section]];
        NSString* balanceStr;
        if (balance < 0.0)
            balanceStr = [NSString stringWithFormat:@"共超支 ¥ %.2f", -balance];
        else if (compareDate([dates objectAtIndex: section], [NSDate date]))
            balanceStr = [NSString stringWithFormat:@"预算还剩 ¥ %.2f", balance];
        else
            balanceStr = [NSString stringWithFormat:@"共节省 ¥ %.2f", balance];
        return balanceStr;
        return [NSString stringWithFormat:@"总消费 ¥ %.2f\n%@", totalExpense, balanceStr];
    }
    return @"";
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate* day = [dates objectAtIndex: indexPath.section];
    // delete the expense from database
    NSArray* expenses = [transactionCache objectForKey:day];
    Expense* expense = [expenses objectAtIndex: indexPath.row];
    ExpenseManager* expMan = [ExpenseManager instance];
    [expMan deleteExpenseById: expense.expenseId];
    // reload cache
    [self forceLoadTransactionOfDateToCache: day];
    
    NSArray * array = [NSArray arrayWithObjects:indexPath, nil];
    [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

- (void)onEdit:(id)sender {
    UIButton* button = sender;
    if (!button)
        return;
    BOOL isEditing = button.selected;

    button.selected = !isEditing;
    [transactionView setEditing:!isEditing animated: YES];
}

- (void)onPickDate:(id)sender {
    DatePickerFullScreen* picker = [DatePickerFullScreen instance];
    picker.reactor = @selector(onEndPickDate:);
    [self presentModalViewController:picker animated:YES];
    //[picker presentOnView:self.view];
}

- (void)onEndPickDate:(NSDate*)day {
}

- (void)dealloc
{
    [super dealloc];
    self.dates = nil;
    self.transactionCache = nil;
}

@end
