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
@synthesize mapRect;

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
    
    MKCoordinateRegion region = [self getBoundsOfExpenses:expenses];
    region = [mapView regionThatFits:region];
    [mapView setRegion:region];
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
        view = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:viewId]autorelease];
    UIButton* accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.rightCalloutAccessoryView = accessory;
    view.canShowCallout = YES;
    view.animatesDrop = YES;
    view.annotation = annotation;
    return view;
}

- (void)mapView:(MKMapView *)map regionWillChangeAnimated:(BOOL)animated {
    self.mapRect = mapView.visibleMapRect;
}

- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated {
    if (!MKMapSizeEqualToSize(mapRect.size, mapView.visibleMapRect.size))
        [self generateAnnotationsThatFits];
}

#pragma mark - Utility Functions

- (void)generateAnnotationsThatFits {
    [mapView removeAnnotations: mapView.annotations];
    
    MKCoordinateRegion bounds = [self getBoundsOfExpenses:expenses];
    CGRect boundsRect = [mapView convertRegion:bounds toRectToView:mapView];
    CGPoint origin = boundsRect.origin;
    
    NSMutableDictionary* cells = [NSMutableDictionary dictionaryWithCapacity:expenses.count];
    float cellWidth = mapView.frame.size.width / 8.0;
    float cellHeight = mapView.frame.size.height / 8.0;
    for (Expense* exp in expenses) {
        if (!exp.useLocation)
            continue;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(exp.latitude, exp.longitude);
        CGPoint point = [mapView convertCoordinate:coordinate toPointToView:mapView];
        int x = (int)((point.x - origin.x) / cellWidth);
        int y = (int)((point.y - origin.y) / cellHeight);
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:y inSection:x];
        NSMutableArray* expensesInCell = [cells objectForKey:indexPath];
        if (!expensesInCell) {
            expensesInCell = [NSMutableArray array];
            [cells setObject:expensesInCell forKey:indexPath];
        }
        [expensesInCell addObject:exp];
    }
    self.annotations = cells;
    
    NSArray* cellKeys = [cells allKeys];
    for (NSIndexPath* indexPath in cellKeys) {
        NSArray* cellExpenses = [cells objectForKey:indexPath];
        double total = 0.0;
        double totalX = 0.0, totalY = 0.0;
        for (Expense* exp in cellExpenses) {
            total += exp.amount;
            CGPoint point = [mapView convertCoordinate:CLLocationCoordinate2DMake(exp.latitude, exp.longitude) toPointToView:mapView];
            totalX += point.x;
            totalY += point.y;
        }
        int expenseCount = cellExpenses.count;
        NSString* subtitle = [NSString stringWithFormat:@"%d笔消费", expenseCount];

        MKPointAnnotation* anno = [[[MKPointAnnotation alloc]init]autorelease];
        // centroid of points
        CGPoint centroid = CGPointMake(totalX / expenseCount, totalY / expenseCount);
        anno.coordinate = [mapView convertPoint:centroid toCoordinateFromView:mapView];
        anno.title = formatAmount(total, YES);
        anno.subtitle = subtitle;
        
        [mapView addAnnotation:anno];
    }
}

- (MKCoordinateRegion)getBoundsOfExpenses:(NSArray *)exps {
    // gets the boundary first
    double minLatitude, maxLatitude, minLongitude, maxLongitude;
    BOOL doInit = YES;
    for (Expense* exp in exps) {
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
    return region;
}

@end
