//
//  IncomeViewController.m
//  woojuu
//
//  Created by syrett on 13-8-25.
//  Copyright (c) 2013年 JingXi Mill. All rights reserved.
//

#import "IncomeViewController.h"
#import "CategoryManager.h"

@interface IncomeViewController ()

@end

@implementation IncomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"here");
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

- (IBAction)onCancel:(id)sender {
  //  self.editingItem = nil;
  //  needReset_ = YES;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
        if (self.dismissedHandler)
            self.dismissedHandler();
    }];
}

- (IBAction)onSave:(id)sender {
}

- (IBAction)onPickdate:(id)sender {
}

- (IBAction)switchToexpense:(id)sender {
    
    MiddleViewController *middleViewController = [[MiddleViewController alloc] initWithNibName:@"MiddleView" bundle:nil];
    [self.view.superview addSubview:middleViewController.view];
    NSLog(@"22222");
    [self.view removeFromSuperview];
 //   [middleViewController release];

}
- (void)dealloc {
    [_uiNumber release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setUiNumber:nil];
    [super viewDidUnload];
}
@end
