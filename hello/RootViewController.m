//
//  RootViewController.m
//  hello
//
//  Created by Rome Lee on 11-5-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        activeController = nil;
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

#pragma mark - Properties

@synthesize todayController;
@synthesize addExpenseController;
@synthesize historyController;
@synthesize tabPanel;

#pragma mark - Event handlers

- (void)presentViewController:(UIViewController*)viewController {
    if (activeController != viewController) {
        [UIView transitionWithView:self.view
                          duration:0.5
                           options:UIViewAnimationOptionTransitionCurlUp
                        animations:^{
                            activeController.view.hidden = YES;
                            viewController.view.hidden = NO;
                        }
                        completion:^(BOOL finished){
                            if (finished) {
                                [activeController performSelector:@selector(viewWillDisappear:)];
                                [viewController performSelector:@selector(viewWillAppear:)];
                                activeController.view.hidden = YES;
                                viewController.view.hidden = NO;
                                activeController = viewController;
                                [self.view sendSubviewToBack:activeController.view];                                
                            }
                        }];
    }
}

- (void)onToday:(id)sender {
    [self presentViewController:todayController];
}

- (void)onAddExpense:(id)sender {
    [self presentModalViewController: self.addExpenseController animated: YES];
}

- (void)onHistory:(id)sender {
    [self presentViewController:historyController];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [activeController performSelector:@selector(viewWillAppear:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.todayController = nil;
    self.addExpenseController = nil;
    self.historyController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if (activeController) {
        [activeController performSelector:@selector(viewWillAppear:)];
    }
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
