//
//  PWDiscoverCollageCollectionViewCell.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageCollectionViewCell.h"

@implementation PWDiscoverCollageCollectionViewCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        int x = 0;
        int y = 0;
        int width = frame.size.width;
        int height = frame.size.height;
        CGRect pictureImageViewFrame = CGRectMake(x,
                                                  y,
                                                  width,
                                                  height);
        self.pictureImageView = [[UIImageView alloc] initWithFrame:pictureImageViewFrame];
        self.pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.pictureImageView.clipsToBounds = YES;
        self.pictureImageView.layer.masksToBounds = YES;
        [self addSubview:self.pictureImageView];
        //View
        self.collageCellView = [[PWDiscoverCollageCellView alloc] initWithFrame:CGRectMake(0,
                                                                                           frame.size.height/2,
                                                                                           frame.size.width,
                                                                                           frame.size.height/2)];
        [self addSubview:self.collageCellView];
    }
    return self;
}

-(void)prepareForReuse{
    self.pictureImageView.frame = CGRectMake(0, 0, 0, 0);
    self.collageCellView.frame = CGRectMake(0, 0, 0, 0);
    self.collageCellView.gradientImageView.frame = CGRectMake(0, 0, 0, 0);
    self.collageCellView.dishNameLabel.frame = CGRectMake(0, 0, 0, 0);
}

@end
