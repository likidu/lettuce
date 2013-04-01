//
//  FullScreenViewController.m
//  woojuu
//
//  Created by Lee Rome on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController () {
    UIView* targetView;
    CGRect sourceFrame;
    CGRect targetFrame;
}

@end

@implementation FullScreenViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        targetView = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped)]autorelease];
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)onTapped {
    if ([self.delegate respondsToSelector:@selector(backgroundViewTapped)])
        [self.delegate backgroundViewTapped];
    BOOL shouldDismiss = YES;
    if ([self.delegate respondsToSelector:@selector(shouldDismissOnBackgroundViewTapped)])
        shouldDismiss = [self.delegate shouldDismissOnBackgroundViewTapped];
    if (shouldDismiss) {
        [self dismiss];
    }
}

- (void)presentView:(UIView *)view {
    UIApplication* app = [UIApplication sharedApplication];
    targetView = view;
    // add self to window
    [app.keyWindow addSubview:self.view];
    [app.keyWindow bringSubviewToFront:self.view];
    CGRect backgroundFrame = self.view.frame;
    backgroundFrame.size = app.keyWindow.frame.size;
    self.view.frame = backgroundFrame;
    // add target view to hierarchy
    [app.keyWindow addSubview:targetView];
    [app.keyWindow bringSubviewToFront:targetView];
    
    // start animation
    self.view.alpha = 0.0;
    targetFrame = targetView.frame;
    targetFrame.origin = app.keyWindow.frame.origin;
    targetFrame = CGRectOffset(targetFrame, app.keyWindow.frame.size.width - targetFrame.size.width, app.keyWindow.frame.size.height - targetFrame.size.height);
    sourceFrame = CGRectOffset(targetFrame, 0.0, targetFrame.size.height);
    targetView.frame = sourceFrame;
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.alpha = 0.6;
        targetView.frame = targetFrame;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^(void){
        self.view.alpha = 0.0;
        targetView.frame = sourceFrame;
    }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.view removeFromSuperview];
                             [targetView removeFromSuperview];
                             if ([self.delegate respondsToSelector:@selector(dismissed)])
                                 [self.delegate dismissed];
                         }
                     }];
}

@end
