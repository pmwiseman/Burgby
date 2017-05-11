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

+(UIAlertController *)callPhoneConfirmationWithNumber:(NSString *)number
{
    NSString *numberString = [NSString stringWithFormat:@"Call %@?", number];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Telephone"
                                                                   message:numberString
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

+(UIAlertController *)noPhoneNumberAvailable
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                   message:@"There is no phone number available at this time."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

+(UIAlertController *)noWebpageAvailable
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops"
                                                                   message:@"There is no webpage available at this time."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    return alert;
}

+(UIAlertController *)turnOnLocationServicesDirectionsAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Error"
                                                                   message:@"Location Services are disabled go to Settings > Privacy > Location Services > PWPrimaryMapViewController and tap While Using"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    return alert;
}

+(UIAlertController *)locationServicesUnavailableAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Error"
                                                                   message:@"Location Services are disabled or a network connection is not available"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    return alert;
}

@end
