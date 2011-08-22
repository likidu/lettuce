//
//  ExpenseHistoryViewController.m
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ExpenseHistoryViewController.h"
#import "ExpenseManager.h"
#import "Utility.h"
#import "Database.h"
#import "CategoryManager.h"
#import "RootViewController.h"

@implementation ExpenseHistoryViewController

+ (ExpenseHistoryViewController *)createInstance {
    ExpenseHistoryViewController* table = [[ExpenseHistoryViewController alloc]initWithNibName:@"ExpenseHistoryViewController" bundle:[NSBundle mainBundle]];
    return table;
}

@synthesize startDate;
@synthesize endDate;
@synthesize cellTemplate;
@synthesize dates;
@synthesize expenseData;
@synthesize totalData;
@synthesize balanceData;
@synthesize tableUpdateDelegate;

@synthesize editing;

#pragma mark - Date range responder

- (void)setStartDate:(NSDate *)date1 endDate:(NSDate *)date2 {
    self.startDate = date1;
    self.endDate = date2;
    [self reload];
}

- (void)reload {
    self.dates = [[ExpenseManager instance]getAvailableDatesBetween:startDate endDate:endDate];
    NSArray* expenses = [[ExpenseManager instance]getExpensesBetween:startDate endDate:endDate orderBy:nil assending:YES];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    for (Expense* exp in expenses) {
        if ([dict objectForKey:DATESTR(exp.date)] == nil)
            [dict setObject:[NSMutableArray array] forKey:DATESTR(exp.date)];
        NSMutableArray* array = [dict objectForKey:DATESTR(exp.date)];
        [array addObject:exp];
    }
    self.expenseData = dict;
    self.totalData = [[ExpenseManager instance]loadTotalBetweenStartDate:startDate endDate:endDate];
    self.balanceData = [[ExpenseManager instance]getBalanceBetweenStartDate:startDate endDate:endDate];
    [self.tableView reloadData];
}

- (BOOL)canEdit {
    return YES;
}

- (BOOL)editing {
    return editing;
}

- (void)setEditing:(BOOL)value {
    editing = value;
    [self.tableView setEditing:value animated:YES];
}

- (void)navigateToData:(NSObject *)data {
    if ([data isKindOfClass:[NSDate class]]) {
        NSDate* date = (NSDate*)data;
        int section = -1;
        for (int i = 0; i < dates.count; i++) {
            if (isSameDay(date, [dates objectAtIndex:i])) {
                section = i;
                break;
            }
        }
        if (section != -1){
            UITableView* tableView = (UITableView*)self.view;
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}

#pragma mark - implementation

static NSString* cellId = @"expenseCell";
static NSString* headerCellId = @"headerCell";
static NSString* footerCellId = @"footerCell";

- (void)loadExpenseCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"ExpenseCell" owner:self options:nil];
}

- (void)loadHeaderCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"CellHeader" owner:self options:nil];
}

- (void)loadFooterCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"CellFooter" owner:self options:nil];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.startDate = nil;
    self.endDate = nil;
    self.dates = nil;
    self.expenseData = nil;
    self.totalData = nil;
    self.balanceData = nil;
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
    return dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate* date = [dates objectAtIndex:section];
    NSArray* expenses = [expenseData objectForKey:DATESTR(date)];
    return expenses.count + 2;
}

- (BOOL)isHeaderAtIndexPath:(NSIndexPath*)indexPath {
    return indexPath.row == 0;
}

- (BOOL)isFooterAtIndexPath:(NSIndexPath*)indexPath {
    NSDate* date = [dates objectAtIndex:indexPath.section];
    NSArray* expenses = [expenseData objectForKey:DATESTR(date)];
    return indexPath.row == expenses.count + 1;
}

- (UITableViewCell*)getProperCell:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell* cell = nil;
    if ([self isHeaderAtIndexPath:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:headerCellId];
        if (!cell)
            [self loadHeaderCell];
    }
    else if ([self isFooterAtIndexPath:indexPath]){
        cell = [tableView dequeueReusableCellWithIdentifier:footerCellId];
        if (!cell)
            [self loadFooterCell];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
            [self loadExpenseCell];
        
    }
    if (!cell) {
        cell = self.cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self getProperCell:tableView forIndexPath:indexPath];
    NSDate* date = (NSDate*)[dates objectAtIndex:indexPath.section];
    
    if ([self isHeaderAtIndexPath:indexPath]) {
        UILabel* label = (UILabel*)[cell viewWithTag:kHeaderText];
        label.text = formatDisplayDate(date);
    }
    else if ([self isFooterAtIndexPath:indexPath]) {
        UIImageView* stamp = (UIImageView*)[cell viewWithTag:kFooterStamp];
        stamp.hidden = [[balanceData objectForKey:DATESTR(date)]doubleValue] >= 0.0;
        UILabel* label = (UILabel*)[cell viewWithTag:kFooterAmount];
        double total = [[totalData objectForKey:DATESTR(date)]doubleValue];
        label.text = [NSString stringWithFormat:@"￥%.2f", total];
    }
    else {
        Expense* exp = [[expenseData objectForKey:DATESTR(date)]objectAtIndex:indexPath.row-1];
        Category* cat = [CategoryManager categoryById:exp.categoryId];
        UIImageView* catIcon = (UIImageView*)[cell viewWithTag:kCellCategoryIcon];
        catIcon.image = [[CategoryManager instance]iconNamed:cat.smallIconName];
        UILabel* catText = (UILabel*)[cell viewWithTag:kCellCategoryText];
        if (exp.notes && exp.notes.length > 0)
            catText.text = exp.notes;
        else
            catText.text = cat.categoryName;
        UIImageView* photoIcon = (UIImageView*)[cell viewWithTag:kCellPhotoIcon];
        photoIcon.hidden = (exp.pictureRef == nil || exp.pictureRef.length == 0);
        UILabel* amount = (UILabel*)[cell viewWithTag:kCellAmount];
        amount.text = [NSString stringWithFormat:@"￥%.2f", exp.amount];
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isHeaderAtIndexPath:indexPath] || [self isFooterAtIndexPath:indexPath])
        return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete expense record from database
        NSDate* date = (NSDate*)[dates objectAtIndex:indexPath.section];
        NSMutableArray* expenses = [expenseData objectForKey:DATESTR(date)];
        Expense* exp = [expenses objectAtIndex:indexPath.row-1];
        [[ExpenseManager instance]deleteExpenseById:exp.expenseId];
        [expenses removeObjectAtIndex:indexPath.row-1];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (expenses.count == 0) {
            // no data for this day. delete the whole section
            [((NSMutableDictionary*)expenseData)removeObjectForKey:DATESTR(date)];
            [((NSMutableArray*)dates)removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            // we still have some records of the day. so refresh the statistics
            double total = [[ExpenseManager instance]loadTotalOfDay:date];
            [((NSMutableDictionary*)totalData)setObject:[NSNumber numberWithDouble:total] forKey:DATESTR(date)];
            double balance = [[ExpenseManager instance]getBalanceOfDay:date];
            [((NSMutableDictionary*)balanceData)setObject:[NSNumber numberWithDouble:balance] forKey:DATESTR(date)];
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [tableUpdateDelegate dataChanged];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // goto the transaction dialog to edit the selected item
    if ([self isHeaderAtIndexPath:indexPath] || [self isFooterAtIndexPath:indexPath])
        return;
    NSDate* date = (NSDate*)[dates objectAtIndex:indexPath.section];
    Expense* expense = [[expenseData objectForKey:DATESTR(date)]objectAtIndex:indexPath.row-1];
    UIApplication* app = [UIApplication sharedApplication];
    RootViewController* rootView = (RootViewController*)app.keyWindow.rootViewController;
    [rootView presentAddTransactionDialog:expense];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

@end
