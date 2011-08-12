//
//  MonthPickerController.m
//  woojuu
//
//  Created by Rome Lee on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MonthPickerController.h"


@implementation MonthPickerController

+ (MonthPickerController *)pickerWithMonths:(NSArray *)months {
    MonthPickerController* picker = [[[MonthPickerController alloc]initWithNibName:@"MonthPickerController" bundle:[NSBundle mainBundle]]autorelease];
    picker.months = months;
    [picker reload];
    return picker;
}

@synthesize months;
@synthesize delegate;
@synthesize sampleLabel;

- (UILabel*)makeLabelWithFrame:(CGRect)frame {
    UILabel* label = [[[UILabel alloc]initWithFrame:frame]autorelease];
    label.textAlignment = sampleLabel.textAlignment;
    label.textColor = sampleLabel.textColor;
    label.shadowColor = sampleLabel.shadowColor;
    label.font = sampleLabel.font;
    label.shadowOffset = sampleLabel.shadowOffset;
    label.backgroundColor = sampleLabel.backgroundColor;
    label.multipleTouchEnabled = sampleLabel.multipleTouchEnabled;
    label.userInteractionEnabled = sampleLabel.userInteractionEnabled;
    return label;
}

- (void)reload {
    // remove all subviews
    for (UIView* view in self.view.subviews) {
        [view removeFromSuperview];
    }

    CGRect frame = self.view.frame;
    CGSize contentSize = frame.size;
    contentSize.width = frame.size.width * months.count;
    UIScrollView* view = (UIScrollView*)self.view;
    view.contentSize = contentSize;
    CGRect rc = {CGPointZero, frame.size};
    for (NSDate* dayOfMonth in months) {
        UILabel* label = [self makeLabelWithFrame:rc];
        label.text = formatMonthString(dayOfMonth);
        [view addSubview:label];
        rc = CGRectOffset(rc, frame.size.width, 0.0);
    }
    view.contentOffset = CGPointMake(-rc.size.width, 0.0);
}

- (void)pickMonth:(NSDate *)dayOfMonth {
    int page = -1;
    for (int i = 0; i < months.count; i++) {
        if (isSameMonth(dayOfMonth, [months objectAtIndex:i])) {
            page = i;
            break;
        }
    }
    if (page == -1)
        return;
    CGRect frame = {CGPointZero, self.view.frame.size};
    frame = CGRectOffset(frame, frame.size.width * page, 0.0);
    UIScrollView* view = (UIScrollView*) self.view;
    [view scrollRectToVisible:frame animated:YES];
}

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
    self.sampleLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Scroll view

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.delegate monthPicked: [months objectAtIndex:scrollView.tag]];
}

@end
