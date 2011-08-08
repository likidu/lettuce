//
//  DropDownViewController.m
//  hello
//
//  Created by Rome Lee on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DropDownViewController.h"


@implementation DropDownViewController

@synthesize dropDownViewDelegate;
@synthesize position;
@synthesize listData;
@synthesize targetView;
@synthesize listSize;
@synthesize listView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dismissList {
    listView.hidden = YES;
    [listView removeFromSuperview];    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView: listView.superview];
    if (!CGRectContainsPoint(listView.frame, touchPoint))
        [self dismissList];
}

- (void)showList {
    listView.hidden = YES;
    CGRect rect = targetView.frame;
    float x = CGRectGetMidX(rect) - listView.frame.size.width / 2.0;
    float y = CGRectGetMaxY(rect);
    rect.origin = CGPointMake(x, y);
    rect.size = listView.frame.size;
    listView.frame = rect;
    [targetView.superview addSubview:listView];
    [targetView.superview bringSubviewToFront:listView];
    [self.tableView reloadData];
    listView.hidden = NO;
    [self.tableView becomeFirstResponder];
}

#pragma mark - Class level functions

static DropDownViewController* g_dropDownViewController = nil;

+ (void)presentDropDownList:(NSArray *)list withDelegate:(id)delegate targetView:(UIView *)view atPosition:(DropDownListPosition)position withSize:(CGSize)size {
    if (!g_dropDownViewController)
        g_dropDownViewController = [[DropDownViewController alloc]initWithNibName:@"DropDownViewController" bundle:[NSBundle mainBundle]];
    
    g_dropDownViewController.listData = list;
    g_dropDownViewController.dropDownViewDelegate = delegate;
    g_dropDownViewController.targetView = view;
    g_dropDownViewController.position = position;
    g_dropDownViewController.listSize = size;
    
    [g_dropDownViewController showList];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[listData objectAtIndex:indexPath.row]description];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissList];
}

@end
