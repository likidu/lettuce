//
//  ExpenseHistoryByLocationViewController.m
//  woojuu
//
//  Created by Rome Lee on 11-9-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ExpenseHistoryByLocationViewController.h"
#import "ExpenseManager.h"
#import "CategoryManager.h"
#import "RootViewController.h"

@implementation ExpenseHistoryByLocationViewController

+ (ExpenseHistoryByLocationViewController *)createInstance {
    return [[[ExpenseHistoryByLocationViewController alloc]initWithNibName:@"ExpenseHistoryByLocationViewController" bundle:[NSBundle mainBundle]]autorelease];
}

@synthesize startDate;
@synthesize endDate;
@synthesize expenses;
@synthesize annotations;

@synthesize mapView;

#pragma mark DateRangeResponder

- (void)setStartDate:(NSDate *)start endDate:(NSDate *)end {
    self.startDate = start;
    self.endDate = end;
    [self reload];
}

- (void)reload {
    [mapView removeAnnotations:mapView.annotations];
    
    self.expenses = [[ExpenseManager instance]getExpensesBetween:startDate endDate:endDate orderBy:nil assending:YES];
    
    // gets the boundary first
    double minLatitude, maxLatitude, minLongitude, maxLongitude;
    BOOL doInit = YES;
    for (Expense* exp in expenses) {
        if (!exp.useLocation)
            continue;
        if (doInit) {
            doInit = NO;
            minLatitude = exp.latitude;
            maxLatitude = exp.latitude;
            minLongitude = exp.longitude;
            maxLongitude = exp.longitude;
        }
        minLatitude = MIN(minLatitude, exp.latitude);
        maxLatitude = MAX(maxLatitude, exp.latitude);
        minLongitude = MIN(minLongitude, exp.longitude);
        maxLongitude = MAX(maxLongitude, exp.longitude);
    }
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLatitude + maxLatitude) * 0.5, (minLongitude + maxLongitude) * 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(maxLatitude - minLatitude, maxLongitude - minLongitude));
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:expenses.count];
    for (Expense* exp in expenses) {
        if (!exp.useLocation)
            continue;
        MKPointAnnotation* anno = [[MKPointAnnotation alloc]init];
        anno.coordinate = CLLocationCoordinate2DMake(exp.latitude, exp.longitude);
        anno.title = formatAmount(exp.amount, YES);
        [array addObject:anno];
    }
    [mapView addAnnotations:array];
}

- (BOOL)canEdit {
    return NO;
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
    mapView.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MapViewDelegate methods

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* viewId = @"ReusableAnnotationView";
    MKPinAnnotationView* view = (MKPinAnnotationView*)[map dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (!view)
        view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:viewId];
    UIButton* accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.rightCalloutAccessoryView = accessory;
    view.canShowCallout = YES;
    view.animatesDrop = YES;
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    
}

@end
