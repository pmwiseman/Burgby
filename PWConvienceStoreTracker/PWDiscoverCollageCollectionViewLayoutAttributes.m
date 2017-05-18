//
//  PWDiscoverCollageCollectionViewLayoutAttributes.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageCollectionViewLayoutAttributes.h"

@interface PWDiscoverCollageCollectionViewLayoutAttributes()

@end

@implementation PWDiscoverCollageCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone {
    PWDiscoverCollageCollectionViewLayoutAttributes *copy = [super copyWithZone:zone];
    copy.cellHeight = self.cellHeight;
    return copy;
}

-(BOOL)isEqual:(id)object {
    PWDiscoverCollageCollectionViewLayoutAttributes *attributes =
    (PWDiscoverCollageCollectionViewLayoutAttributes *)object;
    if(attributes.cellHeight == self.cellHeight) {
        return [super isEqual:object];
    }
    return NO;
}

@end

