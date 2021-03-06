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
#import "UIColor+Helper.h"

@interface OverviewByCategoryViewController()

@property(nonatomic,retain) Dimmer* dimmer;
@property(nonatomic,assign) int firstFixedCategoryId;

@end

@implementation OverviewByCategoryViewController

@synthesize cellTemplate;
@synthesize table;
@synthesize categories;
@synthesize numbers;
@synthesize amounts;
@synthesize startDate;
@synthesize endDate;
@synthesize delegate;

@synthesize dimmer;
@synthesize firstFixedCategoryId;

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
    self.dimmer = [Dimmer dimmerWithView:self.summaryView];
    
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

- (UITableViewCell*)loadCell:(BOOL)isFixed {
    static NSString *CellIdentifier = @"overviewByCategoryCell";
    static NSString* FixedCellIdentifier = @"overviewByCategoryFixedCell";
    
    NSString* cellId = isFixed ? FixedCellIdentifier : CellIdentifier;
    NSString* cellNibName = isFixed ? @"OverviewByCategoryFixedCell" : @"OverviewByCategoryCell";
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        if (!cellTemplate) {
            [[NSBundle mainBundle]loadNibNamed:cellNibName owner:self options:nil];
        }
        cell = cellTemplate;
        self.cellTemplate = nil;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor slateColor];
        cell.selectedBackgroundView = bgColorView;
        [bgColorView release];
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
    int catId = [[categories objectAtIndex:indexPath.row]intValue];
    Category* cat = [CategoryManager categoryById:catId];
    CategoryManager* catMan = [CategoryManager instance];
    
    UITableViewCell* cell = [self loadCell: catId >= FIXED_EXPENSE_CATEGORY_ID_START];
    
    UIImageView* catIconView = (UIImageView*)[cell viewWithTag:kCellCategoryIcon];
    UILabel* catTextLabel = (UILabel*)[cell viewWithTag:kCellCategoryText];
    UILabel* numberLabel = (UILabel*)[cell viewWithTag:kCellNumber];
    UILabel* amountLabel = (UILabel*)[cell viewWithTag:kCellAmount];
    UIImageView* catDashline = (UIImageView*)[cell viewWithTag:kCellDashLine];
    
    if (catIconView && catTextLabel && numberLabel && amountLabel) {
        // category
        UIImage* catIcon = [catMan iconNamed: cat.smallIconName];
        catIconView.image = catIcon;
        catTextLabel.text = cat.categoryName;
        // number
        int number = [[numbers objectAtIndex:indexPath.row]intValue];
        numberLabel.text = [NSString stringWithFormat:@"x %d", number];
        // amount
        double amount = [[amounts objectAtIndex:indexPath.row]doubleValue];
        amountLabel.text = formatAmount(amount, NO);
        
        catDashline.hidden = (catId != self.firstFixedCategoryId) || (indexPath.row == 0);
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
    NSDictionary* dict = [Statistics getTotalByCategoryfromDate:startDate toDate:endDate excludeFixedExpenses:NO];
    self.categories = [dict valueForKey:@"categories"];
    self.numbers = [dict valueForKey:@"numbers"];
    self.amounts = [dict valueForKey:@"amounts"];
    [self.table reloadData];
    [self.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    double totalRegularExpense = 0.0, totalFixedExpense = 0.0;
    BOOL fixedCategoryStarted = NO;
    for (int i = 0; i < categories.count; ++i) {
        if ([[categories objectAtIndex:i]intValue] < FIXED_EXPENSE_CATEGORY_ID_START)
            totalRegularExpense += [[amounts objectAtIndex:i]doubleValue];
        else {
            totalFixedExpense += [[amounts objectAtIndex:i]doubleValue];
            if (!fixedCategoryStarted) {
                self.firstFixedCategoryId = [[categories objectAtIndex:i]intValue];
                fixedCategoryStarted = YES;
            }
        }
    }
    
    self.totalRegularExpenseLabel.text = [NSString stringWithFormat:@"日常支出 %@", formatAmount(totalRegularExpense, NO)];
    self.totalFixedExpenseLabel.text = [NSString stringWithFormat:@"固定支出 %@", formatAmount(totalFixedExpense, NO)];
}

- (BOOL)canEdit {
    return NO;
}

#pragma mark - scroll view

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.dimmer hide];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self.dimmer show];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.dimmer show];
}

@end
