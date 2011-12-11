//
//  BuddgetView.m
//  hello
//
//  Created by Rome Lee on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BudgetView.h"
#import "BudgetManager.h"

@implementation BudgetView

@synthesize uiBudgetEditBox;
@synthesize uiVacationBudgetEditBox;

static BudgetView* g_budgetView = nil;

+ (BudgetView *)instance {
    if (!g_budgetView)
        g_budgetView = [[BudgetView alloc]initWithNibName:@"BudgetView" bundle:[NSBundle mainBundle]];
    return g_budgetView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    BudgetManager* budMan = [BudgetManager instance];
    double budget = [budMan getCurrentBudget];
    double vacationBudget = [budMan getCurrentVacationBudget];
    uiBudgetEditBox.placeholder = [NSString stringWithFormat: @"¥ %.2f", budget];
    uiBudgetEditBox.text = nil;
    uiVacationBudgetEditBox.placeholder = [NSString stringWithFormat: @"¥ %.2f", vacationBudget];
    uiVacationBudgetEditBox.text = nil;
    [uiBudgetEditBox becomeFirstResponder];
}

- (void)onCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSave:(id)sender {
    BudgetManager* budMan = [BudgetManager instance];
    double budget = [uiBudgetEditBox.text doubleValue];
    double vacationBudget = [uiVacationBudgetEditBox.text doubleValue];
    if (budget <= 0.0 && vacationBudget <= 0.0)
        return;
    
    if (budget <= 0.0)
        budget = [budMan getCurrentBudget];
    if (vacationBudget <= 0.0)
        vacationBudget = [budMan getCurrentVacationBudget];

    [budMan setBudgetOfDay:[NSDate date] withAmount:budget withVacationAmount:vacationBudget];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc
{
    [super dealloc];
    self.uiBudgetEditBox = nil;
    self.uiVacationBudgetEditBox = nil;}

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.uiBudgetEditBox = nil;
    self.uiVacationBudgetEditBox = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
