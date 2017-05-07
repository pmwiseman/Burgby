//
//  PWFullSizeImageVenueTableViewCell.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWFullSizeImageVenueTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *addressTextView;
@property (strong, nonatomic) UILabel *distanceLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  nameHeight:(int)nameHeight;

@end
