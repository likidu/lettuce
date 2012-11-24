//
//  HistoryViewFrame.m
//  woojuu
//
//  Created by Lee Rome on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewFrame.h"

@implementation UINavigationBar(CustomBackgroundExtension)

- (void)drawRect:(CGRect)rect {
    UIImage* image = [UIImage imageNamed:@"headerbar.png"];
    [image drawInRect:rect];
}

@end

@implementation HistoryViewFrame

@synthesize navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    // Do any additional setup after loading the view from its nib.
    if (!self.navController) {
        HistoryRootView* rootView = (HistoryRootView*)[HistoryRootView instanceFromNib];
        self.navController = [[[UINavigationController alloc]initWithRootViewController:rootView]autorelease];
        UIImage* image = [UIImage imageNamed:@"headerbar.png"];
        if ([navController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
//        else {
//            UIImageView* view = [[[UIImageView alloc]initWithImage:image]autorelease];
//            [view setTag:kSCNavBarImageTag];
//            [navController.navigationBar insertSubview:view atIndex:0];
//            [navController.navigationBar bringSubviewToFront:view];
//        }
        [self.view addSubview:navController.view];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
