//
//  PWVenueCell.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWImageView.h"

@interface PWVenueCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) PWImageView *backgroundImageView;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  nameHeight:(int)theNameHeight
               addressHeight:(int)theAddressHeight
                  cellHeight:(CGFloat)theCellHeight
                   cellWidth:(CGFloat)theCellWidth;
+(CGRect)getTextSize:(NSString *)text
            fontSize:(CGFloat)theFontSize
        boundingSize:(CGSize)theBoundingSize;
+(CGFloat)getStandardNameWidthWithFrame:(CGRect)frame;
+(CGFloat)getCellHeightWithAddressFrame:(CGRect)addressFrame
                              nameFrame:(CGRect)nameFrame;
+(CGFloat)getCellHeightWithAddress:(NSString *)theAddress
                              name:(NSString *)theName
                      addressWidth:(CGFloat)addressWidth
                         nameWidth:(CGFloat)nameWidth;
+(CGFloat)getStandardAddressWidthWithFrame:(CGRect)frame;

@end
