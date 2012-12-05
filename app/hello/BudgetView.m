//
//  BuddgetView.m
//  hello
//
//  Created by Rome Lee on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetView.h"
#import "PlanManager.h"

@implementation BudgetView

@synthesize uiBudgetEditBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    double budget = [PlanManager getBudgetOfMonth:[NSDate date]];
    uiBudgetEditBox.placeholder = [NSString stringWithFormat: @"¥ %.2f", budget];
    uiBudgetEditBox.text = nil;
    [uiBudgetEditBox becomeFirstResponder];
}

- (void)onCancel:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSave:(id)sender {
    if (![uiBudgetEditBox.text isEqualToString:@""]) {
        double budget = [uiBudgetEditBox.text doubleValue];
        if (budget <= 0.0) {
            UIAlertView* alert = [[[UIAlertView alloc]initWithTitle:@"莴苣账本" message:@"月预算不能为零或负数" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]autorelease];
            [alert show];
            return;
        }

        [PlanManager setBudget:budget ofMonth:[NSDate date]];
    }

    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    self.uiBudgetEditBox = nil;
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
}

- (void)viewDidUnload
{    
    self.uiBudgetEditBox = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
