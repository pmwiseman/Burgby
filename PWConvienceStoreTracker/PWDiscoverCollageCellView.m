//
//  PWDiscoverCollageCellView.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageCellView.h"

@implementation PWDiscoverCollageCellView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //View
        self.gradientImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.gradientImageView.image = [UIImage imageNamed:@"Gradient_Image"];
        self.gradientImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.gradientImageView];
        self.dishNameLabel = [[PWBottomAlignedTextLabel alloc] initWithFrame:self.gradientImageView.frame];
        self.dishNameLabel.textColor = [UIColor whiteColor];
        if(frame.size.height > 260){
            self.dishNameLabel.font = [UIFont boldSystemFontOfSize:34.0];
        }else if(frame.size.width > 220){
            self.dishNameLabel.font = [UIFont boldSystemFontOfSize:22.0];
        }else {
            self.dishNameLabel.font = [UIFont boldSystemFontOfSize:16.0];
        }
        
        self.dishNameLabel.textAlignment = NSTextAlignmentLeft;
        self.dishNameLabel.numberOfLines = 0;
        self.dishNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.dishNameLabel];
    }
    return self;
}

@end
