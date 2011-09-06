//
//  SettingView.m
//  hello
//
//  Created by Rome Lee on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"
#import "BudgetView.h"
#import "AboutViewController.h"

@implementation SettingView

@synthesize settingTableView;
@synthesize yesNoSwitch;

@synthesize imgAbout;
@synthesize imgBudget;
@synthesize imgStartup;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imgAbout = [UIImage imageNamed:@"settings.about.png"];
        self.imgBudget = [UIImage imageNamed:@"settings.budget.png"];
        self.imgStartup = [UIImage imageNamed:@"settings.startup.png"];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    self.imgAbout = nil;
    self.imgBudget = nil;
    self.imgStartup = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)onOk:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSwitch {
    [[NSUserDefaults standardUserDefaults]setBool:yesNoSwitch.on forKey:@"TransactionViewAtStartup"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    settingTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.settingTableView = nil;
    self.yesNoSwitch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    yesNoSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:@"TransactionViewAtStartup"];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* kBudgetCellId = @"SettingCell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kBudgetCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBudgetCellId]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"设置预算";
            cell.imageView.image = imgBudget;
        }
        else {
            cell.textLabel.text = @"快速记账";
            cell.imageView.image = imgStartup;
            cell.accessoryView = yesNoSwitch;
        }
    }
    else {
        // about view
        cell.textLabel.text = @"关于";
        cell.imageView.image = imgAbout;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[self rootViewController]presentModalViewController:[BudgetView instance] animated:YES];
    }
    else if (indexPath.section == 1) {
        [[self rootViewController]presentModalViewController:[AboutViewController instance] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0)
        return @"每次打开程序直接进入记账界面";
    return @"";    
}

@end
