//
//  VenueObject.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "VenueObject.h"

@implementation VenueObject

-(instancetype)initWithLatitude:(float)theLat
                      longitude:(float)theLon
                           name:(NSString *)theName
                        address:(NSString *)theAddress
                       distance:(NSString *)theDistance
              simplifiedAddress:(NSString *)theSimplifiedAddress
                        venueId:(NSString *)theVenueId
                    phoneNumber:(NSString *)thePhoneNumber
                        website:(NSString *)theWebsite
                      urlString:(NSString *)theDefaultImageUrlString
{
    self = [super init];
    if(self){
        self.latitude = theLat;
        self.longitude = theLon;
        self.name = theName;
        self.address = theAddress;
        self.distance = theDistance;
        self.simplifiedAddress = theSimplifiedAddress;
        self.venueId = theVenueId;
        self.phoneNumber = thePhoneNumber;
        self.website = theWebsite;
        self.defaultImageUrlString = theDefaultImageUrlString;
    }
    
    return self;
}

@end
