//
//  PWLocationManager.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/8/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface PWLocationManager : NSObject <CLLocationManagerDelegate>

//Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign) int previousStatusValue;
@property (strong, nonatomic) NSMutableArray *queuedLocationUpdateJobs;

//-(void)configureLocationManagerWithDelegate:(id)delegate;
-(void)getCurrentLocation;
-(void)queueJobForLocationUpdate:(void (^)())jobRun;
-(void)stopUpdatingCurrentLocation;
+(instancetype)sharedManager;

@end
