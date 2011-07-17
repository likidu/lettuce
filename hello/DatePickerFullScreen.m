//
//  DatePickerFullScreen.m
//  hello
//
//  Created by Rome Lee on 11-5-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DatePickerFullScreen.h"

DatePickerFullScreen* g_datePickerFullScreenInstance = nil;

@implementation DatePickerFullScreen

@synthesize reactor;
@synthesize object;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.object = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    BOOL shouldRotate = (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    return shouldRotate;
}

#pragma mark - Event Handlers

- (void)onEndEdit:(id)sender {
    [self.view removeFromSuperview];
    NSDate* day = [NSDate date];
    [object performSelector:reactor withObject:day];
}

#pragma mark - Member functions

+ (DatePickerFullScreen*)instance {
    if (g_datePickerFullScreenInstance == nil) {
        g_datePickerFullScreenInstance = [[DatePickerFullScreen alloc]initWithNibName:@"DatePickerFullScreen" bundle:[NSBundle mainBundle]];
    }
    return g_datePickerFullScreenInstance;
}

- (void)presentOnView:(UIView *)view {
    self.object = view;
    
    self.view.frame = view.bounds;
    [view addSubview:self.view];
}

#pragma mark - UIPickViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Text";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - UIPickViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

@end
