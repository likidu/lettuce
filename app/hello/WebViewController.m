//
//  WebViewController.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-6-4.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView;
@synthesize startUrl;

- (id)initWithURL:(NSString *)url
{
    self = [super initWithNibName:@"WebViewController.xib" bundle:nil];
    if (self)
    {
        // Custom initialization
        self.startUrl = url;
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

    // Load url.
    NSURL* url = [NSURL URLWithString:startUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc 
{
    [super dealloc];
}

# pragma mark - Web View Delegate

- (void)webViewDidFinishLoad:(UIWebView *)view
{
    id url = view.request.URL.absoluteString;
    if ([url rangeOfString:@"/login_success/v1.0/"].location != NSNotFound)
    {
        // Authentication complete and cookie is set successfully.
        // Close the web view here.
        [view loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    }
}
@end
