//
//  PWPhotoGalleryCollectionViewController.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueObject.h"
#import "PWNoResultsLabel.h"

@interface PWPhotoGalleryCollectionViewController : UICollectionViewController
<UIScrollViewDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, PWNoResultsLabelDelegate>

@property (strong, nonatomic) VenueObject *venueObject;

@end
