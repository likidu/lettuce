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

@synthesize table;
@synthesize contentView;
@synthesize scrollView;

static AboutViewController* g_aboutViewController = nil;

+ (AboutViewController *)instance {
    if (!g_aboutViewController)
        g_aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
    return g_aboutViewController;
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
    table.allowsSelection = YES;
    table.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = self.contentView.frame.size;
    [self.scrollView addSubview:self.contentView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.table = nil;
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

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* kCellId = @"UrlCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId]autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }

    if (indexPath.row == 0) {
        cell.textLabel.text = @"访问莴苣网站";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"关注莴苣微博";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"给我们发送邮件";
    }
    else {
        cell.textLabel.text = @"为莴苣加油";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIApplication* app = [UIApplication sharedApplication];
    if (indexPath.row == 0) {
        [app openURL:[NSURL URLWithString:@"http://www.woojuu.cc"]];
    }
    else if (indexPath.row == 1) {
        [app openURL:[NSURL URLWithString:@"http://www.weibo.com/woojuu"]];
    }
    else if (indexPath.row == 2){
        if (![MFMailComposeViewController canSendMail])
            return;
        MFMailComposeViewController* controller = [[[MFMailComposeViewController alloc]init]autorelease];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"莴苣账本问题反馈"];
        [controller setToRecipients:[NSArray arrayWithObject:@"support@woojuu.cc"]];
        [self presentModalViewController:controller animated:YES];
    }
    else {
        [app openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id457874572?mt=8"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
