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
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

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
    
    self.overviewByCategory = (OverviewByCategoryViewController*)[OverviewByCategoryViewController instanceFromNib];
    self.overviewByCategory.delegate = self;
    
    [self.view addSubview:self.overviewByCategory.view];
    self.overviewByCategory.view.frame = self.tableViewPlaceHolder.frame;
    [self.view bringSubviewToFront:self.overviewByCategory.view];
    
    [self.view layoutSubviews];
    
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
    [self.overviewByCategory setStartDate:self.startDate endDate:self.endDate];
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

@end
