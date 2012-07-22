//
//  ReorderCategoryViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReorderCategoryViewController.h"

@interface ReorderCategoryViewController ()

@end

@implementation ReorderCategoryViewController
+ (ReorderCategoryViewController*) createInstance{
    ReorderCategoryViewController* instance = [[[ReorderCategoryViewController alloc]initWithNibName:@"ReorderCategoryViewController" bundle:[NSBundle mainBundle]]autorelease];
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onReturn:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
