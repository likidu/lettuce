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
static UserAccountViewController* _instance = nil;

@implementation UserAccountViewController
@synthesize sinaWebView;
+ (UserAccountViewController*) instance{
    if (_instance == nil) {
        _instance = [[UserAccountViewController alloc] initWithNibName:@"UserAccountViewController" bundle:[NSBundle mainBundle]];
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
}

- (void)viewDidUnload
{
    [self setSinaWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [sinaWebView release];
    [super dealloc];
}
@end
