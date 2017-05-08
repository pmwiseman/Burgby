//
//  PWVenueDetailActionOptionTableViewCell.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWVenueDetailActionOptionTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *actionOptionLabel;
@property (strong, nonatomic) UIImageView *actionOptionImageView;

-(id)initWithStyle:(UITableViewCellStyle)style
   reuseIdentifier:(NSString *)reuseIdentifier
        cellHeight:(CGFloat)cellheight
         cellWidth:(CGFloat)cellWidth;

@end
