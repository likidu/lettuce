//
//  UIImageNoteViewController.m
//  woojuu
//
//  Created by Rome Lee on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIImageNoteViewController.h"


@implementation UIImageNoteViewController

@synthesize delegate;
@synthesize imageNote;
@synthesize scrollView;
@synthesize imageView;

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
    self.imageNote = nil;
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
    self.scrollView = nil;
    self.imageView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    imageView.image = imageNote;
    scrollView.zoomScale = 1.0;
}

- (void)viewWillDisappear:(BOOL)animated {
    imageView.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - event handlers
- (void)onDone {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onDeleteImage {
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"莴苣账本" message:@"即将删除图片，本操作不可恢复，确定要这样吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认删除", nil];
    [view show];
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self dismissModalViewControllerAnimated:YES];
        [delegate imageDeleted];
    }
}

#pragma mark - scroll view delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}

@end
