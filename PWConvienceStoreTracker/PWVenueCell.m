//
//  PWVenueCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWVenueCell.h"

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
        UIImageView *backgroundImageOverlayView = [[UIImageView alloc] initWithFrame:self.backgroundImageView.frame];
        backgroundImageOverlayView.image = [UIImage imageNamed:@"Cell_Background_Image_Overlay"];
        backgroundImageOverlayView.contentMode = UIViewContentModeScaleToFill;
        backgroundImageOverlayView.clipsToBounds = YES;
        [self addSubview:backgroundImageOverlayView];
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

#pragma mark - Sizing

+(CGFloat)getCellHeightWithAddressFrame:(CGRect)addressFrame
                              nameFrame:(CGRect)nameFrame {
    int cellHeight = 50;
    CGFloat combinedHeight = cellHeight + nameFrame.size.height + addressFrame.size.height;
    return combinedHeight;
}

+(CGFloat)getCellHeightWithAddress:(NSString *)theAddress
                              name:(NSString *)theName
                      addressWidth:(CGFloat)addressWidth
                         nameWidth:(CGFloat)nameWidth {
    int cellHeight = 50;
    CGSize standardAddressSize = CGSizeMake(addressWidth,
                                            CGFLOAT_MAX);
    CGSize standardNameSize = CGSizeMake(nameWidth,
                                         CGFLOAT_MAX);
    CGRect nameFrame = [self getTextSize:theName
                                fontSize:17.0
                            boundingSize:standardNameSize];
    CGRect addressFrame = [self getTextSize:theAddress
                                   fontSize:12.0
                               boundingSize:standardAddressSize];
    CGFloat combinedHeight = cellHeight + nameFrame.size.height + addressFrame.size.height;
    return combinedHeight;
}

+(CGRect)getTextSize:(NSString *)text
            fontSize:(CGFloat)theFontSize
        boundingSize:(CGSize)theBoundingSize {
    CGRect frame = [text boundingRectWithSize:theBoundingSize
                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:theFontSize]}
                                     context:nil];
    frame.size.height = frame.size.height + standardTextPadding;
    return frame;
}

+(CGFloat)getStandardNameWidthWithFrame:(CGRect)frame {
    CGFloat nameWidth = frame.size.width - (standardXOffset * 3) - standardLocationWidth;
    return ceilf(nameWidth);
}

+(CGFloat)getStandardAddressWidthWithFrame:(CGRect)frame {
    CGFloat addressWidth = frame.size.width - (standardXOffset * 2);
    return ceilf(addressWidth);
}

@end
