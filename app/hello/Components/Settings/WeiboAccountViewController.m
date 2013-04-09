//
//  WeiboAccountViewController.m
//  woojuu
//
//  Created by Liki Du on 4/9/13.
//  Copyright (c) 2013 JingXi Mill. All rights reserved.
//

#import "WeiboAccountViewController.h"

@interface WeiboAccountViewController ()

@end

@implementation WeiboAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_weiboAuthorizationView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWeiboAuthorizationView:nil];
    [super viewDidUnload];
}
@end
