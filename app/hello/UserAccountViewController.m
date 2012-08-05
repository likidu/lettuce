//
//  UserAccountViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAccountViewController.h"

@interface UserAccountViewController ()

@end

@implementation UserAccountViewController

@synthesize sinaWebView;

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
}

- (void)viewDidUnload
{
    [self setSinaWebView:nil];
    [super viewDidUnload];
    
    self.sinaWebView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://wbjk.info:8080/lettuce/login/v1.0/"]];
    [self.sinaWebView loadRequest: request];
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
    [super dealloc];
}

#pragma mark - web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(webView.request.URL.host);
}

@end
