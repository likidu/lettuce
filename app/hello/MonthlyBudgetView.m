//
//  MonthlyBudgetView.m
//  woojuu
//
//  Created by Lee Rome on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MonthlyBudgetView.h"

@implementation MonthlyBudgetView

@synthesize budgetField;
@synthesize controller;
@synthesize navigationData;
@synthesize goForward;

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
    if (self.goForward)
        [controller forward];
    else
        [controller backward];
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
    self.budgetField = nil;
    self.navigationData = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [budgetField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


- (void)onNext:(id)sender {
    NSRange range = {0,1};
    NSString* strValue = [budgetField.text stringByReplacingCharactersInRange:range withString:@""];
    double budget = [strValue doubleValue];
    //double income = [[navigationData objectForKey:@"income"]doubleValue];
    if (budget > 999999999999.0 || budget < 1.0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入月预算" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [navigationData setObject:[NSNumber numberWithDouble:budget] forKey:@"budget"];
    self.goForward = YES;
    [budgetField resignFirstResponder];
}

- (void)onPrev:(id)sender {
    self.goForward = NO;
    [budgetField resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* strCur = textField.text;  

    //1. When inputting the first number, add prefix “¥”
    if (![strCur compare:@""]) {
        [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:@"¥"]];
        return YES;
    }
    
    int length = [strCur length];
    
    //2. Avoid deleting “¥” by returning NO
    if ( range.location == 0 ){
        if([string compare:@""])
            return NO;
        
        //if all text is selected, just clear all
        if(range.length == length) 
            return YES;
        
        [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:@"¥"]];
        return NO;
    }
    
    //3. Deleting all the number will also delete "¥" 
    if(length == range.length+1 && range.location == 1)
    {  
    
        if (![string compare:@""]) {
            [textField setText:@""];
            return NO;
        }
   
    }

    return YES;
}



@end
