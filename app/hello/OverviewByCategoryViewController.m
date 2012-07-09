//
//  OverviewByCategoryViewController.m
//  woojuu
//
//  Created by Lee Rome on 12-6-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OverviewByCategoryViewController.h"
#import "Statistics.h"
#import "CategoryManager.h"

@implementation OverviewByCategoryViewController

@synthesize cellTemplate;
@synthesize table;
@synthesize categories;
@synthesize numbers;
@synthesize amounts;
@synthesize startDate;
@synthesize endDate;
@synthesize delegate;

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
    self.table.scrollsToTop = YES;

    self.startDate = firstDayOfMonth(firstMonthOfYear([NSDate date]));
    self.endDate = lastDayOfMonth(lastMonthOfYear([NSDate date]));
    
    [self reload];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.cellTemplate = nil;
    self.table = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell*)loadCell {
    static NSString *CellIdentifier = @"OverviewByCategoryCell";
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (!cellTemplate) {
            [[NSBundle mainBundle]loadNibNamed:@"OverviewByCategoryCell" owner:self options:nil];
        }
        cell = cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self loadCell];
    
    UIImageView* catIconView = (UIImageView*)[cell viewWithTag:kCellCategoryIcon];
    UILabel* catTextLabel = (UILabel*)[cell viewWithTag:kCellCategoryText];
    UILabel* numberLabel = (UILabel*)[cell viewWithTag:kCellNumber];
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:kCellAmount];
    
    if (catIconView && catTextLabel && numberLabel && amountLabel) {
        // category
        int catId = [[categories objectAtIndex:indexPath.row]intValue];
        Category* cat = [CategoryManager categoryById:catId];
        CategoryManager* catMan = [CategoryManager instance];
        UIImage* catIcon = [catMan iconNamed: cat.smallIconName];
        catIconView.image = catIcon;
        catTextLabel.text = cat.categoryName;
        // number
        int number = [[numbers objectAtIndex:indexPath.row]intValue];
        numberLabel.text = [NSString stringWithFormat:@"x %d", number];
        // amount
        double amount = [[amounts objectAtIndex:indexPath.row]doubleValue];
        amountLabel.text = formatAmount(amount, NO);
    }
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int categoryId = [[self.categories objectAtIndex:indexPath.row]intValue];
    [delegate pickedCategory: categoryId];
}

#pragma mark - date range responder

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.startDate = start;
    self.endDate = end;
    [self reload];
}

- (void)reload {
    NSDictionary* dict = [Statistics getTotalByCategoryfromDate:startDate toDate:endDate excludeFixedExpenses:YES];
    self.categories = [dict valueForKey:@"categories"];
    self.numbers = [dict valueForKey:@"numbers"];
    self.amounts = [dict valueForKey:@"amounts"];
    [self.table reloadData];
    [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (BOOL)canEdit {
    return NO;
}

@end
