//
//  AboutViewController.m
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize table;

static AboutViewController* g_aboutViewController = nil;

+ (AboutViewController *)instance {
    if (!g_aboutViewController)
        g_aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    return g_aboutViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    // Do any additional setup after loading the view from its nib.
    table.allowsSelection = YES;
    table.backgroundColor = [UIColor clearColor];
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

- (void)onOk {
    [self dismissModalViewControllerAnimated: YES];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* kCellId = @"UrlCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }

    if (indexPath.row == 0) {
        cell.textLabel.text = @"访问莴苣网站";
    }
    else {
        cell.textLabel.text = @"关注莴苣微博";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIApplication* app = [UIApplication sharedApplication];
    if (indexPath.row == 0) {
        [app openURL:[NSURL URLWithString:@"http://www.woojuu.cc"]];
    }
    else {
        [app openURL:[NSURL URLWithString:@"http://www.weibo.com/woojuu"]];
    }
}

@end
