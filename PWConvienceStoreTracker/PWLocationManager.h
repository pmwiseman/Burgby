//
//  PWLocationManager.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/8/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface PWLocationManager : NSObject

//Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign) int previousStatusValue;

-(void)configureLocationManagerWithDelegate:(id)delegate;
-(void)getCurrentLocation;
-(void)stopUpdatingCurrentLocation;

@end
