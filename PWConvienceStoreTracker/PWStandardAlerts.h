//
//  PWStandardAlerts.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PWStandardAlerts : NSObject

+(UIAlertController *)networkErrorAlertController;
+(UIAlertController *)noPhoneNumberAvailable;
+(UIAlertController *)callPhoneConfirmationWithNumber:(NSString *)number;
+(UIAlertController *)noWebpageAvailable;
+(UIAlertController *)turnOnLocationServicesDirectionsAlert;
+(UIAlertController *)locationServicesUnavailableAlert;

@end
