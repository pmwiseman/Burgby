//
//  PWSizeCalculator.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWSizeCalculator.h"

@implementation PWSizeCalculator

//View Constants
static int const standardXOffset = 8;
static int const standardLocationWidth = 50;
static int const standardTextPadding = 2;

#pragma mark - Sizing

+(CGFloat)getCellHeightWithAddressFrame:(CGRect)addressFrame
                              nameFrame:(CGRect)nameFrame {
    int cellHeight = 50;
    CGFloat combinedHeight = cellHeight + nameFrame.size.height + addressFrame.size.height;
    return combinedHeight;
}

+(CGFloat)getCellHeightWithAddress:(NSString *)theAddress
                              name:(NSString *)theName
                      addressWidth:(CGFloat)addressWidth
                         nameWidth:(CGFloat)nameWidth {
    int cellHeight = 50;
    CGSize standardAddressSize = CGSizeMake(addressWidth,
                                            CGFLOAT_MAX);
    CGSize standardNameSize = CGSizeMake(nameWidth,
                                         CGFLOAT_MAX);
    CGRect nameFrame = [self getTextSize:theName
                                fontSize:17.0
                            boundingSize:standardNameSize];
    CGRect addressFrame = [self getTextSize:theAddress
                                   fontSize:12.0
                               boundingSize:standardAddressSize];
    CGFloat combinedHeight = cellHeight + nameFrame.size.height + addressFrame.size.height;
    return combinedHeight;
}

+(CGRect)getTextSize:(NSString *)text
            fontSize:(CGFloat)theFontSize
        boundingSize:(CGSize)theBoundingSize {
    CGRect frame = [text boundingRectWithSize:theBoundingSize
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:theFontSize]}
                                      context:nil];
    frame.size.height = frame.size.height + standardTextPadding;
    return frame;
}

+(CGFloat)getStandardNameWidthWithFrame:(CGRect)frame {
    CGFloat nameWidth = frame.size.width - (standardXOffset * 3) - standardLocationWidth;
    return ceilf(nameWidth);
}

+(CGFloat)getStandardAddressWidthWithFrame:(CGRect)frame {
    CGFloat addressWidth = frame.size.width - (standardXOffset * 2);
    return ceilf(addressWidth);
}

@end
