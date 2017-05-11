//
//  PWVenuePhotoObject.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWVenuePhotoObject.h"

@implementation PWVenuePhotoObject

-(id)initWithPhotoUrlString:(NSString *)thePhotoUrlString {
    self = [super init];
    if(self){
        self.photoUrlString = thePhotoUrlString;
    }
    return self;
}

@end
