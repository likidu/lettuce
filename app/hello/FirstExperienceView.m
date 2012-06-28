//
//  FirstExperienceView.m
//  woojuu
//
//  Created by Lee Rome on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstExperienceView.h"
#import "WelcomeView.h"
#import "MonthlyIncomeView.h"
#import "MonthlyBudgetView.h"
#import "NewFeaturesView.h"
#import "PlanManager.h"

@implementation FirstExperienceView

@synthesize navigationItems;
@synthesize activeItemIndex;
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

#pragma mark - Navigation Controller

- (void)finish {
    double budget = [[navigationData objectForKey:@"budget"]doubleValue];
    [PlanManager setBudget:budget ofMonth:[NSDate date]];

    [self dismissModalViewControllerAnimated:YES];
}

- (void)forward {
    if (activeItemIndex == navigationItems.count - 1) {
        [self finish];
    }
    if (activeItemIndex >= navigationItems.count - 1)
        return;
    UIViewController* oldView = [navigationItems objectAtIndex:activeItemIndex];
    self.activeItemIndex++;
    UIViewController* newView = [navigationItems objectAtIndex:activeItemIndex];
    
    [UIView transitionFromView:oldView.view toView:newView.view duration:0.5 options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished) {
        if (!finished)
            return;
        
        if (![self.view.subviews containsObject:newView.view]) {
            [self.view addSubview:newView.view];
        }
        
        [self.view bringSubviewToFront:newView.view];
    }];
}

- (void)backward {
    if (activeItemIndex <= 0)
        return;
    UIViewController* oldView = [navigationItems objectAtIndex:activeItemIndex];
    self.activeItemIndex--;
    UIViewController* newView = [navigationItems objectAtIndex:activeItemIndex];
    [UIView transitionFromView:oldView.view toView:newView.view duration:0.5 options:UIViewAnimationOptionTransitionCurlDown completion:^(BOOL finished) {
        [self.view bringSubviewToFront:newView.view];
    }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray* items = [NSMutableArray arrayWithCapacity: 4];
    id<NavigationItem> item = nil;
    item = [[[WelcomeView alloc]initWithNibName:@"WelcomeView" bundle:[NSBundle mainBundle]]autorelease];
    [items addObject:item];
    //item = [[[MonthlyIncomeView alloc]initWithNibName:@"MonthlyIncomeView" bundle:[NSBundle mainBundle]]autorelease];
    //[items addObject:item];
    item = [[[MonthlyBudgetView alloc]initWithNibName:@"MonthlyBudgetView" bundle:[NSBundle mainBundle]]autorelease];
    [items addObject:item];
    item = [[[NewFeaturesView alloc]initWithNibName:@"NewFeaturesView" bundle:[NSBundle mainBundle]]autorelease];
    [items addObject:item];
    self.navigationItems = items;
    self.activeItemIndex = 0;
    self.navigationData = [NSMutableDictionary dictionary];
    
    for (id<NavigationItem> item in navigationItems) {
        [item setData:navigationData];
        [item setController:self];
    }
    
    // show first view
    UIViewController* firstView = [items objectAtIndex:0];
    [self.view addSubview: firstView.view];
    [self.view bringSubviewToFront:firstView.view];
}

- (void)viewWillAppear:(BOOL)animated {
    //[[self.view findFirstResponder]resignFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.navigationItems = nil;
    self.activeItemIndex = 0;
    self.navigationData = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
