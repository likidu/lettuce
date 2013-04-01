//
//  LocationManager.m
//  woojuu
//
//  Created by Rome Lee on 11-9-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"

static LocationManager* g_instance = nil;

@implementation LocationManager

+ (void)tryUpdateLocation {
    if (!g_instance) {
        g_instance = [[LocationManager alloc]init];
    }
}

+ (void)tryPause {
    if (g_instance) {
        [g_instance pause];
    }
}

+ (void)tryResume {
    if (g_instance) {
        [g_instance resume];
    }
}

+ (void)tryTerminate {
    CLEAN_RELEASE(g_instance);
}

+ (BOOL)isLocationAvailable {
    if (!g_instance)
        return NO;
    return [g_instance locationAvailable];
}

+ (CLLocationCoordinate2D)getCurrentLocation {
    if (g_instance && [g_instance locationAvailable])
        return [g_instance currentLocation];
    return CLLocationCoordinate2DMake(0.0, 0.0);
}

#pragma mark class members

- (id)init {
    self = [super init];
    if (self) {
        
        _locationAvailable = NO;
        _locMan = nil;
        
        if ([CLLocationManager locationServicesEnabled]) {
            _locMan = [[CLLocationManager alloc]init];
            _locMan.delegate = self;
            _locMan.purpose = @"按消费地点自动归类";
            [_locMan startMonitoringSignificantLocationChanges];
        }
    }
    return self;
}
             
- (void)dealloc {
    if (_locMan) {
        [_locMan stopMonitoringSignificantLocationChanges];
        CLEAN_RELEASE(_locMan);
    }
    [super dealloc];
}

- (BOOL)locationAvailable {
    return _locationAvailable;
}

- (CLLocationCoordinate2D)currentLocation {
    return _currentLocation;
}

- (void)pause {
    if (_locMan)
        [_locMan stopMonitoringSignificantLocationChanges];
}

- (void)resume {
    if (_locMan)
        [_locMan startMonitoringSignificantLocationChanges];
}

#pragma mark CLLocationMangerDelegate implementations

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        _locationAvailable = YES;
        _currentLocation = _locMan.location.coordinate;
        return;
    }
    
    _locationAvailable = NO;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _locationAvailable = NO;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _locationAvailable = YES;
    _currentLocation = newLocation.coordinate;
}

@end
