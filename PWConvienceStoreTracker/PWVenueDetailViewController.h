//
//  PWVenueDetailViewController.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueObject.h"
@import CoreLocation;

@interface PWVenueDetailViewController : UIViewController <NSURLSessionDelegate,
NSURLSessionDataDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) VenueObject *venueObject;

@end
