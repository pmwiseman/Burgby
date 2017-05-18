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
#import "VenueObject.h"

@interface PWNetworkManager : NSObject

+(void)getNearbyFoodWithLocationString:(NSString *)locationString
                          searchString:(NSString *)searchString
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude
                            urlSession:(NSURLSession *)session
                       completionBlock:(void (^)(NSArray *results))processVenues
                          failureBlock:(void (^)(NSError *error))processError;
+(void)getVenueImageWithVenue:(VenueObject *)venue
                       session:(NSURLSession *)session
               completionBlock:(void (^)(NSString *imageUrlString))processUrl;
+(void)loadImageWithUrlString:(NSString *)urlString
              completionBlock:(void (^)(UIImage *image))processImage;
+(void)getVenueImagesWithVenue:(VenueObject *)venue
                       session:(NSURLSession *)session
               completionBlock:(void (^)(NSArray *imageUrlStringArray))processImages;
+(void)getTrendingVenues;

@end
