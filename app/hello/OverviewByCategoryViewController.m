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

+ (OverviewByCategoryViewController *)createInstance {
    return [[[OverviewByCategoryViewController alloc]initWithNibName:@"OverviewByCategoryViewController" bundle:[NSBundle mainBundle]]autorelease];
}

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
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay fromDate:[NSDate date]];
    comp.month = 1;
    comp.day = 1;
    self.startDate = [cal dateFromComponents:comp];
    comp.month = 12;
    comp.day = 31;
    self.endDate = [cal dateFromComponents:comp];
    
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
}

- (BOOL)canEdit {
    return NO;
}

@end
