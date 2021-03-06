//
//  RootViewController.m
//  hello
//
//  Created by Rome Lee on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Mixpanel.h"
#import "UIAlertView+Helper.h"

#import "RootViewController.h"
#import "MiddleViewController.h"
#import "FirstExperienceView.h"
#import "PlanManager.h"
#import "MiddleViewController.h"
#import "objc/runtime.h"

@implementation RootViewController

- (void)dealloc
{
    self.firstUxImage = nil;
    self.firstUxButton = nil;
    self.firstUxImageView = nil;

    self.todayController = nil;
    self.historyController = nil;
    self.tabPanel = nil;
    self.todayButton = nil;
    self.historyButton = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Properties

@synthesize todayController;
@synthesize historyController;
@synthesize tabPanel;
@synthesize todayButton;
@synthesize historyButton;
@synthesize firstUxImage;
@synthesize firstUxImageView;
@synthesize firstUxButton;
@synthesize clientPanel;

#pragma mark - Event handlers

- (void)presentViewController:(UIViewController*)viewController {
    if (activeController != viewController) {
        [activeController performSelector:@selector(viewWillDisappear:)];
        [viewController performSelector:@selector(viewWillAppear:)];
        [UIView transitionWithView:self.clientPanel
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            activeController.view.hidden = YES;
                            viewController.view.hidden = NO;
                        }
                        completion:^(BOOL finished){
                            if (finished) {
                                [self.clientPanel sendSubviewToBack:activeController.view]; 
                                [activeController performSelector:@selector(viewDidDisappear:)];
                                activeController = viewController;
                                [activeController performSelector:@selector(viewDidAppear:)];
                                [activeController.view setNeedsLayout];
                                [activeController.view layoutIfNeeded];
                            }
                        }];
    }
}

- (void)onToday:(id)sender {
    todayButton.selected = YES;
    historyButton.selected = NO;
    [self presentViewController:todayController];
}

- (void)onAddExpense:(id)sender {
  Mixpanel *mixpanel = [Mixpanel sharedInstance];
  [mixpanel track:@"Clicked Button"];

  
  [MiddleViewController showAddTransactionView:nil];
}

- (void)onHistory:(id)sender {
    historyButton.selected = YES;
    todayButton.selected = NO;
    [self presentViewController:historyController];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (viewInitialized)
        return;
    viewInitialized = YES;
    
    // set tab button tool button style
    makeToolButton(self.todayButton);
    makeToolButton(self.historyButton);

    // Do any additional setup after loading the view from its nib.
    CGRect subViewBounds = self.clientPanel.bounds;
    
    todayController.view.frame = subViewBounds;
    [self.clientPanel addSubview: todayController.view];
    [todayController.view layoutSubviews];
    [self.clientPanel sendSubviewToBack: todayController.view];
    
    historyController.view.frame = subViewBounds;
    [self.clientPanel addSubview: historyController.view];
    [historyController.view layoutSubviews];
    [self.clientPanel sendSubviewToBack: historyController.view];
    historyController.view.hidden = YES;
    
    activeController = todayController;
    todayButton.selected = YES;
    [activeController performSelector:@selector(viewWillAppear:)];
    
    // set tint color for navigation items
    UIImage* buttonBackground = [UIImage imageNamed:@"back.button.png"];
    buttonBackground = [buttonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 10)];
    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:buttonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    buttonBackground = [UIImage imageNamed:@"back.button.down.png"];
    buttonBackground = [buttonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 10)];
    [[UIBarButtonItem appearance]setBackButtonBackgroundImage:buttonBackground forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    buttonBackground = [UIImage imageNamed:@"button.base.png"];
    buttonBackground = [buttonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [[UIBarButtonItem appearance]setBackgroundImage:buttonBackground forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    buttonBackground = [UIImage imageNamed:@"button.selected.png"];
    buttonBackground = [buttonBackground resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
    [[UIBarButtonItem appearance]setBackgroundImage:buttonBackground forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    UIImage* header = [UIImage imageNamed:@"headerbar.png"];
    [[UINavigationBar appearance]setBackgroundImage:header forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setValue:[UIColor colorWithRed:0.114 green:0.30 blue:0.0 alpha:1.0] forKey:UITextAttributeTextColor];
    [attributes setValue:[UIColor colorWithWhite:1.0 alpha:0.8] forKey:UITextAttributeTextShadowColor];
    [attributes setValue:[NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)] forKey:UITextAttributeTextShadowOffset];
    [[UIBarButtonItem appearance]setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:attributes forState:UIControlStateHighlighted];
    
    [[UINavigationBar appearance]setTitleTextAttributes:attributes];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    viewInitialized = NO;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.todayController = nil;
    self.historyController = nil;
    self.tabPanel = nil;
    self.todayButton = nil;
    self.historyButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if (activeController)
        [activeController performSelector:@selector(viewWillAppear:)];
}

- (void)viewDidAppear:(BOOL)animated {
    if (activeController)
        [activeController performSelector:@selector(viewDidAppear:)];
    
    if ([PlanManager firstDayOfPlan] == nil) {
        UIViewController* firstExperienceView = [FirstExperienceView instanceFromNib];
        [self presentViewController:firstExperienceView animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (activeController)
        [activeController performSelector:@selector(viewWillDisappear:)];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (activeController)
        [activeController performSelector:@selector(viewDidDisappear:)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [activeController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [activeController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

@end
