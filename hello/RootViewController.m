//
//  RootViewController.m
//  hello
//
//  Created by Rome Lee on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MiddleViewController.h"

@implementation RootViewController

static NSString* g_key1stUx = @"DidShow1stUx";

- (void)dealloc
{
    [super dealloc];
    self.firstUxImage = nil;
    self.firstUxButton = nil;
    self.firstUxImageView = nil;

    self.todayController = nil;
    self.addExpenseController = nil;
    self.historyController = nil;
    self.tabPanel = nil;
    self.todayButton = nil;
    self.historyButton = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Properties

@synthesize todayController;
@synthesize addExpenseController;
@synthesize historyController;
@synthesize tabPanel;
@synthesize todayButton;
@synthesize historyButton;
@synthesize firstUxImage;
@synthesize firstUxImageView;
@synthesize firstUxButton;

#pragma mark - Event handlers

- (void)presentViewController:(UIViewController*)viewController {
    if (activeController != viewController) {
        [activeController performSelector:@selector(viewWillDisappear:)];
        [viewController performSelector:@selector(viewWillAppear:)];
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            activeController.view.hidden = YES;
                            viewController.view.hidden = NO;
                        }
                        completion:^(BOOL finished){
                            if (finished) {
                                [self.view sendSubviewToBack:activeController.view]; 
                                [activeController performSelector:@selector(viewDidDisappear:)];
                                activeController = viewController;
                                [activeController performSelector:@selector(viewDidAppear:)];
                            }
                        }];
    }
}

- (void)onToday:(id)sender {
    todayButton.selected = YES;
    historyButton.selected = NO;
    [self presentViewController:todayController];
}

- (void)presentAddTransactionDialog:(NSObject*)data {
    if (self.modalViewController)
        return;
    if (data) {
        MiddleViewController* vc = (MiddleViewController*)addExpenseController;
        vc.editingItem = (Expense*)data;
    }
    [[self rootViewController]presentModalViewController: self.addExpenseController animated: YES];
}

- (void)onAddExpense:(id)sender {
    [self presentAddTransactionDialog: nil];
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
    
    // Do any additional setup after loading the view from its nib.
    CGRect subViewBounds = self.view.bounds;
    subViewBounds.size.height -= tabPanel.bounds.size.height;
    
    todayController.view.frame = subViewBounds;
    [self.view addSubview: todayController.view];
    [self.view sendSubviewToBack: todayController.view];
    
    historyController.view.frame = subViewBounds;
    [self.view addSubview: historyController.view];
    [self.view sendSubviewToBack: historyController.view];
    historyController.view.hidden = YES;
    
    activeController = todayController;
    todayButton.selected = YES;
    [activeController performSelector:@selector(viewWillAppear:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    viewInitialized = NO;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.todayController = nil;
    self.addExpenseController = nil;
    self.historyController = nil;
    self.tabPanel = nil;
    self.todayButton = nil;
    self.historyButton = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    // set tab button tool button style
    makeToolButton(self.todayButton);
    makeToolButton(self.historyButton);
    
    if (activeController)
        [activeController performSelector:@selector(viewWillAppear:)];
}

- (void)viewDidAppear:(BOOL)animated {
    if (activeController)
        [activeController performSelector:@selector(viewDidAppear:)];
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
