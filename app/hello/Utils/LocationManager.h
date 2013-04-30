//
//  LocationManager.h
//  woojuu
//
//  Created by Rome Lee on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocationManager : NSObject<CLLocationManagerDelegate> {
    BOOL _locationAvailable;
    CLLocationManager* _locMan;
    CLLocationCoordinate2D _currentLocation;
}

+ (void)tryUpdateLocation;
+ (void)tryPause;
+ (void)tryResume;
+ (void)tryTerminate;
+ (BOOL)isLocationAvailable;
+ (CLLocationCoordinate2D)getCurrentLocation;

- (BOOL)locationAvailable;
- (CLLocationCoordinate2D)currentLocation;
- (void)pause;
- (void)resume;

@end
