//
//  PWImageView.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/6/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWImageView : UIImageView

@property (strong, nonatomic) UIImage *cachedImage;
@property (strong, nonatomic) NSString *cache;
-(void)getImageWithUrlString:(NSString *)urlString;
-(void)getVenueImagesWithVenueId:(NSString *)venueId
                         session:(NSURLSession *)session;

@end
