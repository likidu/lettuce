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

@synthesize yearData;
@synthesize tableView;
@synthesize summaryView;

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
    self.navigationItem.title = @"2012年";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:nil action:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    self.yearData = [Statistics getMonthsOfYear:[NSDate date]];
    self.summaryView.alpha = 1.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 animations:^() {
        self.summaryView.alpha = 0.0;
    }];
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (yearData)
        return yearData.count;
    else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"monthOfYearCell"]autorelease];
    NSString* titleText = [NSString stringWithFormat:@"%@月", [yearData objectAtIndex: indexPath.row]];
    cell.textLabel.text = titleText;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;    
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ExpenseByCategoryViewController* viewController = [[[ExpenseByCategoryViewController alloc]initWithNibName:@"ExpenseByCategoryViewController" bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

#pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

@end
