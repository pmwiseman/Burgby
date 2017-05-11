//
//  PWPhotoGalleryCollectionViewCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWPhotoGalleryCollectionViewCell.h"

@implementation PWPhotoGalleryCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //Image View
        int imageX = 0;
        int imageY = 0;
        int imageWidth = frame.size.width;
        int imageHeight = frame.size.height;
        CGRect imageFrame = CGRectMake(imageX,
                                       imageY,
                                       imageWidth,
                                       imageHeight);
        self.imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
    }
    return self;
}

@end
