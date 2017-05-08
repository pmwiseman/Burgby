//
//  PWDetailActionOptionObject.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDetailActionOptionObject.h"

@implementation PWDetailActionOptionObject

-(id)initWithTitle:(NSString *)theTitle
       imageString:(NSString *)theImageString
               tag:(int)theTag
  associatedString:(NSString *)theAssociatedString {
    self = [super init];
    if(self){
        if(theAssociatedString.length <= 0) {
            theImageString = [NSString stringWithFormat:@"%@_Gray", theImageString];
        }
        self.image = [UIImage imageNamed:theImageString];
        self.title = theTitle;
        self.tag = theTag;
    }
    return self;
}

@end
