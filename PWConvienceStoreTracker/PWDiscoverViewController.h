//
//  PWDiscoverViewController.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDiscoverCollageCollectionViewLayout.h"
#import <CoreLocation/CoreLocation.h>

@interface PWDiscoverViewController : UICollectionViewController <PWDiscoverCollageCollectionViewLayoutDelegate,
UIScrollViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) CLLocation *currentLocation;

@end
