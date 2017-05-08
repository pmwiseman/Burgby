//
//  PWSizeCalculator.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PWSizeCalculator : NSObject

+(CGRect)getTextSize:(NSString *)text
            fontSize:(CGFloat)theFontSize
        boundingSize:(CGSize)theBoundingSize;
+(CGFloat)getStandardNameWidthWithFrame:(CGRect)frame;
+(CGFloat)getCellHeightWithAddressFrame:(CGRect)addressFrame
                              nameFrame:(CGRect)nameFrame;
+(CGFloat)getCellHeightWithAddress:(NSString *)theAddress
                              name:(NSString *)theName
                      addressWidth:(CGFloat)addressWidth
                         nameWidth:(CGFloat)nameWidth;
+(CGFloat)getStandardAddressWidthWithFrame:(CGRect)frame;

@end
