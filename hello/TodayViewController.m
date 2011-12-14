//
//  TodayViewController.m
//  woojuu
//
//  Created by Lee Rome on 11-12-10.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TodayViewController.h"

@implementation TodayViewController

@synthesize progressView;

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

    NSMutableDictionary* theme = [[[NSMutableDictionary alloc]init]autorelease];
    UIImage* flagImage = [UIImage imageNamed:@"img.flag.png"];
    UIImage* image = [UIImage imageNamed:@"img.bar.start.darkred.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.darkred.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.darkred.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [progressView registerTheme:theme withName:@"darkred"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.green.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.green.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.green.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [progressView registerTheme:theme withName:@"green"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.red.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.red.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.red.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [progressView registerTheme:theme withName:@"red"];
    
    theme = [[[NSMutableDictionary alloc]init]autorelease];
    image = [UIImage imageNamed:@"img.bar.start.orange.png"];
    [theme setObject:image forKey:@"img.bar.start"];
    image = [UIImage imageNamed:@"img.bar.pattern.orange.png"];
    [theme setObject:image forKey:@"img.bar.pattern"];
    image = [UIImage imageNamed:@"img.bar.end.orange.png"];
    [theme setObject:image forKey:@"img.bar.end"];
    [theme setObject:flagImage forKey:@"img.flag"];
    [progressView registerTheme:theme withName:@"orange"];

    progressView.activeThemeName = @"orange";
    progressView.progress = 0.6;
    progressView.flagProgress = 0.5;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
