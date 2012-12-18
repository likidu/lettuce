//
//  MonthViewRoot.m
//  woojuu
//
//  Created by Lee Rome on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MonthViewRoot.h"
#import "SingleCategoryByMonthView.h"

@implementation MonthViewRoot

@synthesize tableViewPlaceHolder;
@synthesize navigationItemView;
@synthesize overviewByCategory;
@synthesize overviewByDate;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

@synthesize viewByCategoryButton;
@synthesize viewByDateButton;
@synthesize viewByCategoryLabel;
@synthesize viewByDateLabel;

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
    // setup view by category view controller
    self.overviewByCategory = (OverviewByCategoryViewController*)[OverviewByCategoryViewController instanceFromNib];
    self.overviewByCategory.delegate = self;
    
    [self.tableViewPlaceHolder addSubview:self.overviewByCategory.view];
    [self.tableViewPlaceHolder bringSubviewToFront:self.overviewByCategory.view];
    self.overviewByCategory.view.frame = self.tableViewPlaceHolder.bounds;
    [self.overviewByCategory.view layoutSubviews];
    
    // setup view by date view controller
    self.overviewByDate = (ExpenseHistoryViewController*)[ExpenseHistoryViewController instanceFromNib];
    [self.tableViewPlaceHolder addSubview:self.overviewByDate.view];
    [self.tableViewPlaceHolder bringSubviewToFront:self.overviewByDate.view];
    self.overviewByDate.view.frame = self.tableViewPlaceHolder.bounds;
    [self.overviewByDate.view layoutSubviews];
    
    // layout and initially hide the by date view controller
    [self.tableViewPlaceHolder layoutSubviews];
    self.overviewByCategory.view.hidden = YES;
    
    if (self.startDate == nil || self.endDate == nil) {
        NSDate* today = [NSDate date];
        self.startDate = firstDayOfMonth(today);
        self.endDate = lastDayOfMonth(today);
    }
    
    self.navigationItem.titleView = self.navigationItemView;
    
    [self reloadAll];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableViewPlaceHolder = nil;
    self.overviewByCategory = nil;
    self.navigationItemView = nil;
    self.viewByCategoryButton = nil;
    self.viewByDateButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - update view content

- (void)viewWillAppear:(BOOL)animated {
    [self reloadAll];
}

- (void)reloadAll {
    if (self.viewByCategoryButton.selected)
        [self.overviewByCategory setStartDate:self.startDate endDate:self.endDate];
    else
        [self.overviewByDate setStartDate:self.startDate endDate:self.endDate];
    
    self.navigationItem.title = formatMonthString(self.startDate);
    self.navigationItemView.text = formatMonthString(self.startDate);
}

#pragma mark - date range responder

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self.startDate = startDate;
    self.endDate = endDate;
    [self reloadAll];
}

- (void)reload {
    [self reloadAll];
}

- (BOOL)canEdit {
    return NO;
}

#pragma mark - report view delegate

- (void)pickedDate:(NSDate *)day {
    
}

- (void)pickedCategory:(int)categoryId {
    SingleCategoryByMonthView* categoryView = (SingleCategoryByMonthView*)[SingleCategoryByMonthView instanceFromNib];
    NSMutableDictionary* options = [NSMutableDictionary dictionary];
    [options setObject:self.startDate forKey:@"startDate"];
    [options setObject:self.endDate forKey:@"endDate"];
    [options setObject:[NSNumber numberWithInt:categoryId] forKey:@"categoryId"];
    [categoryView setViewOptions:options];
    [self.navigationController pushViewController:categoryView animated:YES];
}

#pragma mark - change view method

- (void)onViewByCategory {
    if (!self.viewByCategoryButton.selected) {
        self.viewByCategoryButton.selected = YES;
        self.viewByDateButton.selected = NO;
        self.overviewByCategory.view.hidden = NO;
        self.overviewByDate.view.hidden = YES;
        self.viewByCategoryLabel.textColor = [self.viewByCategoryButton titleColorForState:UIControlStateSelected];
        self.viewByDateLabel.textColor = [self.viewByDateButton titleColorForState:UIControlStateNormal];
        [self reloadAll];
    }    
}

- (void)onViewByDate {
    if (!self.viewByDateButton.selected) {
        self.viewByCategoryButton.selected = NO;
        self.viewByDateButton.selected = YES;
        self.overviewByCategory.view.hidden = YES;
        self.overviewByDate.view.hidden = NO;
        self.viewByCategoryLabel.textColor = [self.viewByCategoryButton titleColorForState:UIControlStateNormal];
        self.viewByDateLabel.textColor = [self.viewByDateButton titleColorForState:UIControlStateSelected];
        [self reloadAll];
    }
}

@end
