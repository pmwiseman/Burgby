//
//  PWPrimaryViewController.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface PWPrimaryViewController : UIViewController <CLLocationManagerDelegate,
NSURLSessionDelegate, NSURLSessionDataDelegate, UISearchBarDelegate, UITableViewDelegate,
UITableViewDataSource, UISearchBarDelegate>

@end