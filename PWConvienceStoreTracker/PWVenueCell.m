//
//  PWVenueCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWVenueCell.h"
#import "PWSizeCalculator.h"
#import "PWNetworkManager.h"

@implementation PWVenueCell

//View Constants
static int const standardXOffset = 8;
static int const standardLocationWidth = 50;
static int const standardTextPadding = 2;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  nameHeight:(int)theNameHeight
               addressHeight:(int)theAddressHeight
                  cellHeight:(CGFloat)theCellHeight
                   cellWidth:(CGFloat)theCellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //standard label width
        int standardLabelWidth = theCellWidth - (standardXOffset * 2);
        //image
        self.backgroundImageView = [[PWImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       theCellWidth,
                                                                       theCellHeight)];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.backgroundColor = [UIColor whiteColor];
        [self.backgroundImageView setImage:[UIImage imageNamed:@"Image_Placeholder"]];
        self.backgroundImageView.clipsToBounds = YES;
        [self addSubview:self.backgroundImageView];
        //background image overlay
        self.backgroundImageOverlayView = [[UIImageView alloc] initWithFrame:self.backgroundImageView.frame];
        self.backgroundImageOverlayView.image = [UIImage imageNamed:@"Cell_Background_Image_Overlay"];
        self.backgroundImageOverlayView.contentMode = UIViewContentModeScaleToFill;
        self.backgroundImageOverlayView.clipsToBounds = YES;
//        [self.backgroundImageOverlayView setHidden:YES];
        [self addSubview:self.backgroundImageOverlayView];
        //address
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(standardXOffset,
                                                                      theCellHeight - theAddressHeight - standardTextPadding,
                                                                      standardLabelWidth,
                                                                      theAddressHeight)];
        self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textColor = [UIColor whiteColor];
        self.addressLabel.font = [UIFont systemFontOfSize:12.0];
        self.addressLabel.userInteractionEnabled = NO;
        [self addSubview:self.addressLabel];
        //name
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(standardXOffset,
                                                                   self.addressLabel.frame.origin.y - 4 - theNameHeight,
                                                                   standardLabelWidth - (standardLocationWidth + standardXOffset),
                                                                   theNameHeight)];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.nameLabel];
        //Distance
        int distanceLabelHeight = 20;
        int distanceLabelWidth = 50;
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(theCellWidth - (distanceLabelWidth + standardXOffset),
                                                                       self.nameLabel.frame.origin.y,
                                                                       distanceLabelWidth,
                                                                       distanceLabelHeight)];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.distanceLabel];
        
        
        
    }
    return self;
}

#pragma mark - Styling

-(void)addGradientOverLayForImageLoad {
    [self.backgroundImageOverlayView setHidden:NO];
    if([self.backgroundImageOverlayView isHidden]){
        
    }
}

#pragma mark - Setup

-(void)setupCellWithVenueObject:(VenueObject *)venueObject
           usingCurrentLocation:(BOOL)currentLocation {
    self.nameLabel.text = venueObject.name;
    self.addressLabel.text = venueObject.address;
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                          delegate:nil
                                                     delegateQueue:nil];
    if(venueObject.cachedImage || [venueObject.defaultImageUrlString isEqualToString:@"default"]){
        if([venueObject.defaultImageUrlString isEqualToString:@"default"]){
            self.backgroundImageView.image = [UIImage imageNamed:@"No_Image"];
        } else {
            self.backgroundImageView.image = venueObject.cachedImage;
        }
    } else {
        [PWNetworkManager getVenueImageWithVenue:venueObject session:session completionBlock:^(NSString *imageUrlString) {
            if(![imageUrlString isEqualToString:@"default"]){
                [PWNetworkManager loadImageWithUrlString:venueObject.defaultImageUrlString completionBlock:^(UIImage *image) {
                    venueObject.cachedImage = image;
                    __weak PWVenueCell *updateCell = self;
                    if(updateCell){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [updateCell addGradientOverLayForImageLoad];
                            updateCell.backgroundImageView.image = image;
                        });
                    }
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    __weak PWVenueCell *updateCell = self;
                    updateCell.backgroundImageView.image = [UIImage imageNamed:@"No_Image"];
                });
            }
        }];
    }
    if(currentLocation){
        if([self.distanceLabel isHidden]){
            [self.distanceLabel setHighlighted:YES];
        }
        self.distanceLabel.text = [NSString stringWithFormat:@"%@mi", venueObject.distance];
    } else {
        [self.distanceLabel setHidden:YES];
    }
}

@end
