//
//  PWVenueCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWVenueCell.h"

@implementation PWVenueCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  nameHeight:(int)nameHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //name
        int nameLabelX = 8;
        int nameLabelY = 8;
        int nameLabelWidth = 265;
        int nameLabelHeight = nameHeight;
        CGRect nameLabelFrame = CGRectMake(nameLabelX,
                                           nameLabelY,
                                           nameLabelWidth,
                                           nameLabelHeight);
        self.nameLabel = [[UILabel alloc] initWithFrame:nameLabelFrame];
        self.nameLabel.numberOfLines = 0;
        self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLabel.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:self.nameLabel];
        //address
        int addressLabelX = 8;
        int addressLabelY = nameLabelY + nameLabelHeight;
        int addressLabelWidth = 250;
        int addressLabelHeight = 40;
        CGRect addressLabelFrame = CGRectMake(addressLabelX,
                                              addressLabelY,
                                              addressLabelWidth,
                                              addressLabelHeight);
        self.addressTextView = [[UILabel alloc] initWithFrame:addressLabelFrame];
        self.addressTextView.lineBreakMode = NSLineBreakByWordWrapping;
        self.addressTextView.numberOfLines = 0;
        self.addressTextView.textColor = [UIColor lightGrayColor];
        self.addressTextView.font = [UIFont systemFontOfSize:12.0];
        self.addressTextView.userInteractionEnabled = NO;
        [self addSubview:self.addressTextView];
        //Distance
        int distanceLabelWidth = 50;
        int distanceLabelX = [[UIScreen mainScreen] bounds].size.width - distanceLabelWidth - 8;
        int distanceLabelY = 8;
        int distanceLabelHeight = 20;
        CGRect distanceLabelFrame = CGRectMake(distanceLabelX,
                                               distanceLabelY,
                                               distanceLabelWidth,
                                               distanceLabelHeight);
        self.distanceLabel = [[UILabel alloc] initWithFrame:distanceLabelFrame];
        self.distanceLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.distanceLabel];
        
    }
    return self;
}

@end
