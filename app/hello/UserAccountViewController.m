//
//  UserAccountViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAccountViewController.h"
#import "NSString+NSStringAdditions.h"
@interface UserAccountViewController ()

@end

@implementation UserAccountViewController

static UserAccountViewController* _instance = nil;
static NSString * BackupTimeKey = @"LastBackupAndRecoverTime";
@synthesize sinaWebView;
@synthesize loginView;
@synthesize backupView;
@synthesize backupAndRestore;
@synthesize labelStatus;
@synthesize imgBackup;
@synthesize imgRestore;

+ (UserAccountViewController *) instance{
    if (_instance == nil) {
        _instance = [[UserAccountViewController alloc]initWithNibName:@"UserAccountViewController" bundle:[NSBundle mainBundle]];
    }
    
    return _instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (IBAction)onReturn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initImages];
}

- (void)viewDidUnload
{
    [self setSinaWebView:nil];
    [self setLoginView:nil];
    [self setBackupView:nil];
    [self setBackupAndRestore:nil];
    [self setLabelStatus:nil];
    [self setImgBackup:nil];
    [self setImgRestore:nil];
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //Check if is login
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://wbjk.info:8080/lettuce/login/v1.0/"]];
    [self.sinaWebView loadRequest: request];
    
    //For backup and restore
    
    NSString* status = [[NSUserDefaults standardUserDefaults]stringForKey:BackupTimeKey];
    if (status) {
        [self.labelStatus setHidden:NO]; 
    }else {
       // [self.labelStatus setHidden:YES];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.sinaWebView.loading) {
        [self.sinaWebView stopLoading];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [sinaWebView release];
    [loginView release];
    [backupView release];
    [backupAndRestore release];
    [labelStatus release];
    [imgBackup release];
    [imgRestore release];
    [super dealloc];
}

#pragma mark - private utilities

- (void)initImages{
    self.imgRestore = [UIImage imageNamed:@"settings.backup.png"];
    self.imgBackup = [UIImage imageNamed:@"settings.backup.png"];
}

- (BOOL)isUserLoggedIn{
    return false;
}

#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {    
    //Hide the webview until it's content is all loaded
    //[self.sinaWebView setHidden:NO];
    
    NSLog(@"%@", webView.request.URL.host);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //Do with specific URL:
    NSString *absoluteUrl = [request.URL absoluteString];
    if ([absoluteUrl contains:@"api.weibo.com/oauth2/authorize?"]) {
        NSLog(@"%@", absoluteUrl);
        //Return NO and set up another NSURLConnection with the same request to set up a delegate to receive the JSON response
        //Suppose login success
       // [self presentViewController:(BackupAndRecoverViewController*)[BackupAndRecoverViewController instanceFromNib] animated:YES completion:nil];
        //[self.sinaWebView setHidden:YES];
    }
    
    return TRUE;
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
            cell.detailTextLabel.text = @"将数据备份到云端";              
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (![self isUserLoggedIn]){            
        }
        
    }
    else if (indexPath.section == 1) {  
        if (![self isUserLoggedIn]){
        }
    } 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1){
        return @"备份至服务器中的数据将加密存放";      
    }
    
    return @"";    
}

@end
