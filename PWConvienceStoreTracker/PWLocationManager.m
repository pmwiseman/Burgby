//
//  PWLocationManager.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/8/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWLocationManager.h"

@implementation PWLocationManager

+(instancetype)sharedManager
{
    static PWLocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
    });
    return sharedLocationManager;
}

//Get the current user location
-(void)getCurrentLocation
{
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
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

-(void)queueJobForLocationUpdate:(void (^)())jobRun
{
    if(!self.queuedLocationUpdateJobs){
        self.queuedLocationUpdateJobs = [[NSMutableArray alloc] init];
    }
    [self.queuedLocationUpdateJobs addObject:jobRun];
    [self getCurrentLocation];
}

-(void)executeQueuedUpdateJobs {
    for(int i=0; i<[self.queuedLocationUpdateJobs count]; i++){
       void(^job)() = [self.queuedLocationUpdateJobs objectAtIndex:i];
        job();
    }
    [self.queuedLocationUpdateJobs removeAllObjects];
}

-(void)cancelQueuedUpdateJobs {
    [self.queuedLocationUpdateJobs removeAllObjects];
}

//-(void)configureLocationManagerWithDelegate:(id)delegate {
//    if(!self.locationManager){
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = delegate;
//    }
//    [self getCurrentLocation];
//}

-(void)stopUpdatingCurrentLocation {
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == 3 || status == 4 || status == 5){
        if(self.previousStatusValue == 0){
            [self getCurrentLocation];
        }
    } else  if(status == 1 || status == 2){
//        UIAlertController *alert = [PWStandardAlerts turnOnLocationServicesDirectionsAlert];
//        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        [alert addAction:dismissAction];
//        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdateNotAuthorized"
//                                                            object:nil
//                                                          userInfo:nil];
        [self cancelQueuedUpdateJobs];
    }
}

//Current user location not returned
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
//    UIAlertController *alert = [PWStandardAlerts locationServicesUnavailableAlert];
//    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [alert addAction:dismissAction];
//    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdateFailed"
//                                                        object:nil
//                                                      userInfo:nil];
    [self cancelQueuedUpdateJobs];
}

//Current user location returned
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //Set the current region
    self.currentLocation = [locations lastObject];
    [self stopUpdatingCurrentLocation];
    [self executeQueuedUpdateJobs];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated"
//                                                        object:nil
//                                                      userInfo:nil];
}

@end
