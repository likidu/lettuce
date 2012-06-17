//
//  HistoryRootView.m
//  woojuu
//
//  Created by Lee Rome on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryRootView.h"
#import "Statistics.h"
#import "ExpenseByCategoryViewController.h"

@implementation HistoryRootView

@synthesize overviewByMonth;
@synthesize overviewByCategory;
@synthesize tableViewPlaceHolder;
@synthesize viewByMonthButton;
@synthesize viewByCategoryButton;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = formatYearString([NSDate date]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
    // create and initialize the overview
    self.overviewByMonth = [OverviewByYearViewController createInstance];
    [self.view addSubview: overviewByMonth.view];
    [self.view bringSubviewToFront:overviewByMonth.view];
    overviewByMonth.view.frame = tableViewPlaceHolder.frame;
    
    self.overviewByCategory = [OverviewByCategoryViewController createInstance];
    [self.view addSubview: overviewByCategory.view];
    [self.view bringSubviewToFront:overviewByCategory.view];
    overviewByCategory.view.frame = tableViewPlaceHolder.frame;
    overviewByCategory.view.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.overviewByMonth = nil;
    self.overviewByCategory = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    if (viewByMonthButton.selected) {
        [overviewByMonth reload];
    }
    else {
        [overviewByCategory reload];
    }
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)onViewByMonth {
    if (!viewByMonthButton.selected) {
        viewByMonthButton.selected = YES;
        viewByCategoryButton.selected = NO;
        
        overviewByMonth.view.hidden = NO;
        overviewByCategory.view.hidden = YES;
    }
}

- (void)onViewByCategory {
    if (!viewByCategoryButton.selected) {
        viewByCategoryButton.selected = YES;
        viewByMonthButton.selected = NO;
        
        overviewByCategory.view.hidden = NO;
        overviewByMonth.view.hidden = YES;
    }
}

@end
