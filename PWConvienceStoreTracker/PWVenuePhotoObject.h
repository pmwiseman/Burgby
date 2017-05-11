//
//  PWVenuePhotoObject.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PWVenuePhotoObject : NSObject

@property (strong, nonatomic) NSString *photoUrlString;
@property (strong, nonatomic) UIImage *loadedImage;

-(id)initWithPhotoUrlString:(NSString *)thePhotoUrlString;

@end
