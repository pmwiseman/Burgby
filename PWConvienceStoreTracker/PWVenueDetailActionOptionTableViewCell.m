//
//  PWVenueDetailActionOptionTableViewCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWVenueDetailActionOptionTableViewCell.h"

@implementation PWVenueDetailActionOptionTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
        cellHeight:(CGFloat)cellheight
         cellWidth:(CGFloat)cellWidth {
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        //Image
        int imagePadding = 8;
        int imageSquareSize = cellheight - (imagePadding * 2);
        self.actionOptionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imagePadding,
                                                                                   imagePadding,
                                                                                   imageSquareSize,
                                                                                   imageSquareSize)];
        [self addSubview:self.actionOptionImageView];
        //Text
        self.actionOptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((imagePadding * 2) + imageSquareSize,
                                                                           0,
                                                                           200,
                                                                           cellheight)];
        [self addSubview:self.actionOptionLabel];
        //Bottom Border
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                        cellheight - 1,
                                                                        cellWidth,
                                                                        1)];
        bottomBorder.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomBorder];
    }
    return self;
}


@end
