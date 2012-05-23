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

@synthesize overviewByYear;
@synthesize tableViewPlaceHolder;

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
    self.overviewByYear = [OverviewByYearViewController createInstance];
    [self.view addSubview: overviewByYear.view];
    [self.view bringSubviewToFront:overviewByYear.view];
    overviewByYear.view.frame = tableViewPlaceHolder.frame;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.overviewByYear = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
}

@end
