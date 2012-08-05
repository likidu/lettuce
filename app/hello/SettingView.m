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
#import "BackupAndRecoverViewController.h"
#import "UserAccountViewController.h"
@implementation SettingView

@synthesize settingTableView;
@synthesize yesNoSwitch;

@synthesize imgAbout;
@synthesize imgBudget;
@synthesize imgStartup;
@synthesize imgAccount;
@synthesize imgBackup;
@synthesize imgCategory;
@synthesize imgPassword;
@synthesize imgReminder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initImages];
    }
    return self;
}

- (void)initImages{    
    self.imgAbout = [UIImage imageNamed:@"settings.about.png"];
    self.imgBudget = [UIImage imageNamed:@"settings.budget.png"];
    self.imgStartup = [UIImage imageNamed:@"settings.startup.png"];
    self.imgAccount = [UIImage imageNamed:@"settings.account.png"];
    self.imgBackup = [UIImage imageNamed:@"settings.backup.png"];
    self.imgCategory = [UIImage imageNamed:@"settings.category.png"];
    self.imgPassword = [UIImage imageNamed:@"settings.password.png"];
    self.imgReminder = [UIImage imageNamed:@"settings.reminder.png"];
}

- (void)dealloc
{
    [super dealloc];
    self.imgAbout = nil;
    self.imgBudget = nil;
    self.imgStartup = nil;
    self.imgAccount = nil;
    self.imgBackup = nil;
    self.imgCategory = nil;
    self.imgPassword = nil;
    self.imgReminder = nil;
    self.settingTableView = nil;
    self.yesNoSwitch = nil;
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
    [self.settingTableView reloadData];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    settingTableView.backgroundColor = [UIColor clearColor];
    [self initImages];
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
    switch (section) {
        case 0:
            return 5;
            break;
            
        case 1:
            return 2;
            break;
            
        case 2:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* kBudgetCellId = @"SettingCell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kBudgetCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBudgetCellId]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"预算设置";
                //cell.detailTextLabel.text
                cell.imageView.image = imgBudget;               
                break;
            case 1:
                cell.textLabel.text = @"本地密码保护";
                cell.imageView.image = imgPassword;               
                break;
            case 2:
                cell.textLabel.text = @"记账提醒";
                cell.imageView.image = imgReminder;               
                break;
            case 3:
                cell.textLabel.text = @"调整类别次序";
                cell.imageView.image = imgCategory;               
                break;
            case 4:
                cell.textLabel.text = @"快速记账";
                cell.imageView.image = imgStartup;
                cell.accessoryView = yesNoSwitch;
                break;
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"备份与恢复";
            cell.imageView.image = imgBackup;
        }
        else {
            cell.textLabel.text = @"我的账号";
            cell.imageView.image = imgAccount;
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
    return 3;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0){
            [self presentModalViewController:[BudgetView instanceFromNib] animated:YES];
        }
    }
    else if (indexPath.section == 1) {  
        if (indexPath.row == 0){
            [self presentModalViewController:[BackupAndRecoverViewController instanceFromNib] animated:YES];
        }
        else if (indexPath.row == 1){
            [self presentModalViewController:[UserAccountViewController instanceFromNib] animated:YES];
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self presentModalViewController:(AboutViewController*)[AboutViewController instanceFromNib] animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"常规";
    }
    else if (section == 1){
        return @"云备份";
    }
    else{
        return @"其他";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0){
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"TransactionViewAtStartup"] == true){
            return @"每次打开程序直接开始记账";      
        }
    }

    return @"";    
}

@end
