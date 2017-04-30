//
//  PWStandardAlerts.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWStandardAlerts.h"

@implementation PWStandardAlerts

+(UIAlertController *)networkErrorAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                   message:@"Check to make sure that your location services are on and you are connected to a network"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    return alert;
}

@end
