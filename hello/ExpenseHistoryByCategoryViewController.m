//
//  ExpenseHistoryByCategoryViewController.m
//  woojuu
//
//  Created by Rome Lee on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ExpenseHistoryByCategoryViewController.h"
#import "ExpenseManager.h"
#import "CategoryManager.h"

@implementation ExpenseHistoryByCategoryViewController

+ (ExpenseHistoryByCategoryViewController *)createInstance {
    return [[[ExpenseHistoryByCategoryViewController alloc]initWithNibName:@"ExpenseHistoryByCategoryViewController" bundle:[NSBundle mainBundle]]autorelease];
}

@synthesize cellTemplate;
@synthesize startDate;
@synthesize endDate;
@synthesize expenseData;
@synthesize totalData;
@synthesize expenses;
@synthesize categories;

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.startDate = start;
    self.endDate = end;
    [self reload];
}

- (void)reload {
    self.expenses = [[ExpenseManager instance]getExpensesBetween:startDate endDate:endDate orderBy:@"CategoryId" assending:YES];
    // group expenses by category id
    NSMutableDictionary* groupedExpenseData = [NSMutableDictionary dictionary];
    NSMutableDictionary* groupedTotalData = [NSMutableDictionary dictionary];
    for (Expense* e in expenses) {
        NSNumber* catId = [NSNumber numberWithInt:e.categoryId];
        if ([groupedExpenseData objectForKey:catId] == nil)
            [groupedExpenseData setObject:[NSMutableArray array] forKey:catId];
        NSMutableArray* arr = [groupedExpenseData objectForKey:catId];
        [arr addObject:e];
        // calculate total
        if ([groupedTotalData objectForKey:catId] == nil)
            [groupedTotalData setObject:[NSNumber numberWithDouble:0.0] forKey:catId];
        NSNumber* number = [groupedTotalData objectForKey:catId];
        number = [NSNumber numberWithDouble: [number doubleValue] + e.amount];
        [groupedTotalData setObject:number forKey:catId];
    }
    self.expenseData = groupedExpenseData;
    self.totalData = groupedTotalData;
    
    NSArray* cats = [groupedExpenseData allKeys];
    cats = [cats sortedArrayUsingComparator:^(id obj1, id obj2){
        NSNumber* a = [groupedTotalData objectForKey:obj1];
        NSNumber* b = [groupedTotalData objectForKey:obj2];
        if ([a doubleValue] > [b doubleValue])
            return NSOrderedAscending;
        else if ([a doubleValue] < [b doubleValue])
            return NSOrderedDescending;
        return NSOrderedSame;
    }];
    self.categories = cats;
    
    [self.tableView reloadData];
}

- (BOOL)canEdit {
    return NO;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    return categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* arr = [expenseData objectForKey:[categories objectAtIndex:section]];
    return arr.count + 2;
}

- (BOOL)isHeaderAtIndexPath:(NSIndexPath*)indexPath {
    return indexPath.row == 0;
}

- (BOOL)isFooterAtIndexPath:(NSIndexPath*)indexPath {
    NSNumber* catId = [categories objectAtIndex:indexPath.section];
    NSArray* arr = [expenseData objectForKey:catId];
    return indexPath.row == arr.count + 1;
}

- (void)loadExpenseCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"ExpenseCellWithDate" owner:self options:nil];
}

- (void)loadHeaderCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"CellHeaderWithIcon" owner:self options:nil];
}

- (void)loadFooterCell{
    if (cellTemplate)
        return;
    [[NSBundle mainBundle]loadNibNamed:@"CellFooterAmountOnly" owner:self options:nil];
}

- (UITableViewCell*)getProperCell:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath{
    static NSString* cellId = @"expenseCell";
    static NSString* headerCellId = @"headerCell";
    static NSString* footerCellId = @"footerCell";
    
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
    NSNumber* catId = (NSNumber*)[categories objectAtIndex:indexPath.section];
    Category* cat = [CategoryManager categoryById:[catId intValue]];
    
    if ([self isHeaderAtIndexPath:indexPath]) {
        UILabel* label = (UILabel*)[cell viewWithTag:kHeaderText];
        label.text = cat.categoryName;
        UIImageView* iconView = (UIImageView*)[cell viewWithTag:kHeaderIcon];
        iconView.image = [[CategoryManager instance]iconNamed:cat.smallIconName];
    }
    else if ([self isFooterAtIndexPath:indexPath]) {
        UILabel* label = (UILabel*)[cell viewWithTag:kFooterAmount];
        double total = [[totalData objectForKey:catId]doubleValue];
        label.text = formatAmount(total, YES);
    }
    else {
        NSArray* arr = [expenseData objectForKey:catId];
        Expense* exp = [arr objectAtIndex:indexPath.row-1];
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
        amount.text = formatAmount(exp.amount, YES);
        UILabel* dateLabel = (UILabel*)[cell viewWithTag:kCellDate];
        dateLabel.text = formatMonthDayString(exp.date);
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
