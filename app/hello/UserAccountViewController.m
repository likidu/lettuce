//
//  UserAccountViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAccountViewController.h"
#import "NSString+Helper.h"
#import "UIAlertView+Helper.h"
#import "Utility.h"

#define STATUS_FORMATTEXT @"%@你好\n上次备份时间为%@"
#define BACKUP_TIME_KEY @"LastBackupAndRecoverTime"
#define WEIBO_USERNAME_KEY @"LastLoginWeiboUserName"
@interface UserAccountViewController ()

@end

@implementation UserAccountViewController

static UserAccountViewController* _instance = nil;
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
    [self initControls];
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
    if (![self isUserLoggedIn]) {
        [self showAuthenticationPage];
    }else {
        [self switchToBackupAndRestore];
    }
    //For backup and restore
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopLoadingWebPage];
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

- (void)initControls{
    self.imgRestore = [UIImage imageNamed:@"settings.backup.png"];
    self.imgBackup = [UIImage imageNamed:@"settings.backup.png"];
    [self refreshStatusLabel];
}

- (BOOL)isUserLoggedIn{
    return true;
}

- (void)switchToLogin{
    [self.backupView setHidden:YES];
    [self.loginView setHidden:NO];
}

- (void)switchToBackupAndRestore{
    [self.loginView setHidden:YES];
    [self.backupView setHidden:NO];   
}

- (void)stopLoadingWebPage{    
    if (self.sinaWebView.loading) {
        [self.sinaWebView stopLoading];
    }
    [self.sinaWebView setHidden:YES];
}

- (void)showAuthenticationPage{
    [self switchToLogin];    
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://wbjk.info:8080/lettuce/login/v1.0/"]];
    [self.sinaWebView loadRequest: request];
}

- (void)refreshStatusLabel{    
    NSString *backupTimeDisplayString = [[NSUserDefaults standardUserDefaults]stringForKey:BACKUP_TIME_KEY];
    NSString *userName = [[NSUserDefaults standardUserDefaults]stringForKey:WEIBO_USERNAME_KEY];
    if (backupTimeDisplayString && userName) {
        [self.labelStatus setText:[NSString stringWithFormat:STATUS_FORMATTEXT, userName, backupTimeDisplayString]];
        [self.labelStatus setHidden:NO];
    }else {      
        [self.labelStatus setHidden:YES]; 
    }
}

#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {    
    //Hide the webview until it's content is all loaded
    [self.sinaWebView setHidden:NO];    
    NSLog(@"From WebViewDidFinishLoad: %@", webView.request.URL.host);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //Do with specific URL:
    NSLog(@"FROM SHOULDSTARTLOADWITHREQUEST: %@",[request.URL absoluteString]);
    NSString *absoluteUrl = [request.URL absoluteString];

    if ([absoluteUrl contains:@"api.weibo.com/oauth2/authorize?"]) {
        NSLog(@"%@", absoluteUrl);
        //Return NO and set up another NSURLConnection with the same request to set up a delegate to receive the JSON response
        //Suppose login success
       // [self presentViewController:(BackupAndRecoverViewController*)[BackupAndRecoverViewController instanceFromNib] animated:YES completion:nil];
        //[self.sinaWebView setHidden:YES];
        [self stopLoadingWebPage];
        //Get username for weibo
        NSString *userName = @"Liangying";
        [[NSUserDefaults standardUserDefaults]setObject:userName forKey:WEIBO_USERNAME_KEY];
        [self refreshStatusLabel];
        
        [self switchToBackupAndRestore];
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
            //cell.detailTextLabel.text = @"将数据备份到云端";              
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"恢复数据";
            cell.imageView.image = imgRestore;
            //cell.detailTextLabel.text = @"从云端恢复数据";
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
            //Show loginView
            [self showAuthenticationPage];
        }else {
            //Popup please wait dialog, showing backup is in progress
            [UIAlertView showWaitNotification:@"正在备份，请稍候"];
            //When finished, set status
            NSString *currrentTime = formatDateToString([NSDate date], @"yyyy-MM-dd hh:mm", [NSTimeZone localTimeZone]);
            [[NSUserDefaults standardUserDefaults]setObject:currrentTime forKey:BACKUP_TIME_KEY];
            [self refreshStatusLabel];
        }
        
    }
    else if (indexPath.section == 1) {  
        if (![self isUserLoggedIn]){
            //Show loginView
            [self showAuthenticationPage];
        }else {
            //Popup dialog, showing restore is in progress
        }
    } 
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1){
        //return @"备份至服务器中的数据将加密存放";      
    }
    
    return @"";    
}

@end
