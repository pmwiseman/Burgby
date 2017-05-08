//
//  PWVenueCell.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWImageView.h"
#import "VenueObject.h"

@interface PWVenueCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) PWImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *backgroundImageOverlayView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  nameHeight:(int)theNameHeight
               addressHeight:(int)theAddressHeight
                  cellHeight:(CGFloat)theCellHeight
                   cellWidth:(CGFloat)theCellWidth;
-(void)addGradientOverLayForImageLoad;
-(void)setupCellWithVenueObject:(VenueObject *)venueObject
           usingCurrentLocation:(BOOL)currentLocation;

@end
