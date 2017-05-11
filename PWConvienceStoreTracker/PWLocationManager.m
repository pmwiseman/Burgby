//
//  PWLocationManager.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/8/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWLocationManager.h"

@implementation PWLocationManager

//Get the current user location
-(void)getCurrentLocation
{
    self.previousStatusValue = [CLLocationManager authorizationStatus];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    } else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted
              && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        self.geoCoder = [[CLGeocoder alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100.0f;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    }
}

-(void)configureLocationManagerWithDelegate:(id)delegate {
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = delegate;
    }
    [self getCurrentLocation];
}

-(void)stopUpdatingCurrentLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

@end
