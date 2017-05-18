//
//  PWBottomAlignedTextLabel.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWBottomAlignedTextLabel.h"

@implementation PWBottomAlignedTextLabel

-(void)drawTextInRect:(CGRect)rect {
    if(self.text) {
        CGSize labelStringSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX) options:
                                  NSStringDrawingUsesLineFragmentOrigin |
                                  NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:self.font}
                                                         context:nil].size;
        [super drawTextInRect:CGRectMake(0, ceilf(CGRectGetHeight(self.frame) - ceilf(labelStringSize.height) - 3), ceilf(CGRectGetWidth(self.frame)), ceilf(labelStringSize.height))];
    } else {
        [super drawTextInRect:rect];
    }
}

@end
