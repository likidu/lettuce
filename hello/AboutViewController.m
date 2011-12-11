//
//  AboutViewController.m
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"
#import "MessageUI/MFMailComposeViewController.h"

@implementation AboutViewController

@synthesize contentView;
@synthesize scrollView;

+ (AboutViewController *)createInstance {
    AboutViewController* instance = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    return instance;
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
    self.contentView = nil;
    self.scrollView = nil;
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
    self.scrollView.contentSize = self.contentView.frame.size;
    [self.scrollView addSubview:self.contentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.contentView = nil;
    self.scrollView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    self.scrollView.contentOffset = CGPointZero;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onOk {
    [self dismissModalViewControllerAnimated: YES];
}

- (void)onWebsite {
    UIApplication* app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:@"http://www.woojuu.cc"]];    
}

- (void)onWeibo {
    UIApplication* app = [UIApplication sharedApplication];    
    [app openURL:[NSURL URLWithString:@"http://www.weibo.com/woojuu"]];
}

- (void)onSupport {
    if (![MFMailComposeViewController canSendMail])
        return;
    MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc]init]autorelease];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"我有话想说"];
    [controller setToRecipients:[NSArray arrayWithObject:@"support@woojuu.cc"]];
    [self presentModalViewController:controller animated:YES];
}

- (void)onRate {
    UIApplication* app = [UIApplication sharedApplication];    
    [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id457874572?mt=8"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
