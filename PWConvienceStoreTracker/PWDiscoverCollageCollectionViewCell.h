//
//  PWDiscoverCollageCollectionViewCell.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWDiscoverCollageCellView.h"

@interface PWDiscoverCollageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *pictureImageView;
@property (strong, nonatomic) PWDiscoverCollageCellView *collageCellView;

@end
