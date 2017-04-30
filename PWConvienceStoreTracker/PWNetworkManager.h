//
//  PWNetworkManager.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PWNetworkManager : NSObject

+(void)getNearbyFoodWithLocationString:(NSString *)locationString
                          searchString:(NSString *)searchString
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude
                            urlSession:(NSURLSession *)session;

@end
