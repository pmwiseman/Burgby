//
//  VenueObject.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VenueObject : NSObject

@property (assign) float latitude;
@property (assign) float longitude;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *distance;
@property (strong, nonatomic) NSString *simplifiedAddress;
@property (strong, nonatomic) NSString *venueId;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *defaultImageUrlString;
@property (strong, nonatomic) UIImage *cachedImage;

-(instancetype)initWithLatitude:(float)theLat
                      longitude:(float)theLon
                           name:(NSString *)theName
                        address:(NSString *)theAddress
                       distance:(NSString *)theDistance
              simplifiedAddress:(NSString *)theSimplifiedAddress
                        venueId:(NSString *)theVenueId
                    phoneNumber:(NSString *)thePhoneNumber
                        website:(NSString *)theWebsite
                      urlString:(NSString *)theDefaultImageUrlString;

@end
