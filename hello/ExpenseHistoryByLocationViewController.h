//
//  ExpenseHistoryByLocationViewController.h
//  woojuu
//
//  Created by Rome Lee on 11-9-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewProtocol.h"

@interface ExpenseHistoryByLocationViewController : UIViewController<DateRangeResponder, MKMapViewDelegate> {
    
}
+ (ExpenseHistoryByLocationViewController*)createInstance;

@property(nonatomic,retain) NSDate* startDate;
@property(nonatomic,retain) NSDate* endDate;
@property(nonatomic,retain) NSArray* expenses;
@property(nonatomic,retain) NSArray* annotations;

@property(nonatomic,retain) IBOutlet MKMapView* mapView;

@end
