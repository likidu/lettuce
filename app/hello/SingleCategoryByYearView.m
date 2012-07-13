//
//  SingleCategoryByYearView.m
//  woojuu
//
//  Created by Lee Rome on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SingleCategoryByYearView.h"
#import "Statistics.h"
#import "CategoryManager.h"

@interface SingleCategoryByYearView ()

@end

@implementation SingleCategoryByYearView

@synthesize cellTemplate;
@synthesize table;
@synthesize navigationItemView;

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize months;
@synthesize numbers;
@synthesize amounts;
@synthesize categoryId;

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

    self.cellTemplate = nil;
    self.table = nil;
    self.navigationItemView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UITableViewCell*)loadCell {
    static NSString* cellId = @"CategoryExpenseCell";
    UITableViewCell* cell = [self.table dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        [[NSBundle mainBundle]loadNibNamed:@"SingleCategoryByYearCell" owner:self options:nil];
        cell = self.cellTemplate;
        self.cellTemplate = nil;
    }
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
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
    return self.numbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [self loadCell];
    if (cell) {
        UILabel* monthLabel = (UILabel*)[cell viewWithTag: kCellDate];
        monthLabel.text = formatMonthOnlyString([self.months objectAtIndex:indexPath.row]);
        UILabel* numberLabel = (UILabel*)[cell viewWithTag:kCellNumber];
        numberLabel.text = [NSString stringWithFormat:@"x %d", [[self.numbers objectAtIndex:indexPath.row]intValue]];
        UILabel* amountLabel = (UILabel*)[cell viewWithTag:kCellAmount];
        amountLabel.text = formatAmount([[self.amounts objectAtIndex:indexPath.row]doubleValue], NO);
    }
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - view option responder

- (void)setViewOptions:(NSDictionary *)options {
    if ([options objectForKey:@"startDate"]) self.startDate = (NSDate*)[options objectForKey:@"startDate"];
    if ([options objectForKey:@"endDate"]) self.endDate = (NSDate*)[options objectForKey:@"endDate"];
    if ([options objectForKey:@"categoryId"]) self.categoryId = [[options objectForKey:@"categoryId"]intValue];

    [self refresh];
}

- (void)refresh {
    NSDictionary* dict = [Statistics getTotalOfCategory:self.categoryId fromMonth:self.startDate toMonth:self.endDate];
    self.months = [dict objectForKey:@"months"];
    self.numbers = [dict objectForKey:@"numbers"];
    self.amounts = [dict objectForKey:@"amounts"];
}

@end
