//
//  BackupAndRecoverViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackupAndRecoverViewController.h"
#import "UserAccountViewController.h"

@interface BackupAndRecoverViewController ()
- (void)initImages;
@end

static BackupAndRecoverViewController* _instance = nil;

@implementation BackupAndRecoverViewController
@synthesize backupAndRestore;
@synthesize imgBackup;
@synthesize imgRestore;

+ (BackupAndRecoverViewController *) instance {
    if (_instance == nil){
        _instance = [[BackupAndRecoverViewController alloc]initWithNibName:@"BackupAndRecoverViewController" bundle:[NSBundle mainBundle]];
    }
    
    return _instance;
}
- (IBAction)onReturn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

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
    self.imgRestore = [UIImage imageNamed:@"settings.backup.png"];
    self.imgBackup = [UIImage imageNamed:@"settings.backup.png"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initImages];
}

- (void)viewDidUnload
{
    [self setBackupAndRestore:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [backupAndRestore release];
    [super dealloc];
    self.imgBackup = nil;
    self.imgRestore = nil;
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* kBudgetCellId = @"SettingCell";
    
    UITableViewCell* cell = [backupAndRestore dequeueReusableCellWithIdentifier:kBudgetCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kBudgetCellId]autorelease];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"备份数据";
            
            cell.imageView.image = imgBackup;
            cell.detailTextLabel.text = @"将数据备份到云端可以避免数据丢失";              
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"恢复数据";
            cell.imageView.image = imgRestore;
            cell.detailTextLabel.text = @"从云端恢复数据";
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

+ (BOOL)isUserLoggedIn{
    return false;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (![BackupAndRecoverViewController isUserLoggedIn]){
            [self presentModalViewController:[UserAccountViewController instanceFromNib] animated:YES];            
        }
            
    }
    else if (indexPath.section == 1) {  
        if (![BackupAndRecoverViewController isUserLoggedIn]){
            [self presentModalViewController:[UserAccountViewController instanceFromNib] animated:YES];
        }
    } 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1){
        return @"备份至服务器中的数据以加密形式存放";      
    }
    
    return @"";    
}


@end
