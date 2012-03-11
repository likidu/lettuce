//
//  MonthlyIncomeView.m
//  woojuu
//
//  Created by Lee Rome on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MonthlyIncomeView.h"
#import "MonthlyBudgetView.h"

@implementation MonthlyIncomeView

@synthesize textView;
@synthesize controller;
@synthesize navigationData;

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

- (void)setData:(NSMutableDictionary *)data {
    self.navigationData = data;
}

#pragma mark - View lifecycle

- (void)keyboardDidHide:(NSNotification*)notification {
    [controller forward];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.  
    self.textView = nil;
    self.navigationData = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [textView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)onNext:(id)sender {
    double income = [textView.text doubleValue];
    if (income > 999999999999.0 || income < 1.0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入月收入" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [navigationData setObject:[NSNumber numberWithDouble:income] forKey:@"income"];
    [textView resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
