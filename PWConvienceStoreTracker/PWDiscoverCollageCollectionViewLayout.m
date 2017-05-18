//
//  PWDiscoverCollageCollectionViewLayout.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageCollectionViewLayout.h"
#import "PWDiscoverCollageCollectionViewLayoutAttributes.h"

@interface PWDiscoverCollageCollectionViewLayout()

@property (strong, nonatomic) NSMutableArray *cache;
@property (assign) CGFloat contentHeight;
@property (assign) CGFloat contentWidth;
@property (strong, nonatomic) NSMutableArray *xOffset;
@property (assign) CGFloat columnWidth;
@property (strong, nonatomic) NSMutableArray *sectionHeaderArray;

@end

@implementation PWDiscoverCollageCollectionViewLayout

static CGFloat cellPadding = 1.0;
static int numberOfColumns = 2;
static int headerHeight = 0;

-(CGFloat)setContentWidth {
    UIEdgeInsets insets = self.collectionView.contentInset;
    return self.collectionView.bounds.size.width - (insets.left + insets.right);
}

-(void)prepareLayout {
    self.contentWidth = [self setContentWidth];
    if(!self.cache){
        self.cache = [[NSMutableArray alloc] init];
    }
    self.sectionHeaderArray = [[NSMutableArray alloc] init];
    int column = 0;
    NSMutableArray *yOffset  = [[NSMutableArray alloc] init];
    for(int x=0; x<[self.collectionView numberOfSections]; x++){
        self.columnWidth = self.contentWidth / (CGFloat)numberOfColumns;
        int randomExtraProportion = arc4random_uniform(10);
        float randomExtraPercentage = randomExtraProportion*0.03;
        int extra = self.columnWidth/(1 + randomExtraPercentage);
        self.xOffset = [[NSMutableArray alloc] init];
        for(int i=0; i<numberOfColumns; i++){
            CGFloat offset;
            if(i == 0){
                offset = (CGFloat)i * self.columnWidth;
            } else {
                offset = (CGFloat)i * extra;
            }
            NSNumber *offsetNumber = [NSNumber numberWithFloat:offset];
            [self.xOffset addObject:offsetNumber];
        }
        if([yOffset count] == 0){
            CGFloat zeroOffset = headerHeight;
            NSNumber *zeroOffsetNumber = [NSNumber numberWithFloat:zeroOffset];
            [self.sectionHeaderArray addObject:zeroOffsetNumber];
            [yOffset addObject:zeroOffsetNumber];
            [yOffset addObject:zeroOffsetNumber];
        } else {
            NSNumber *newOffset = [yOffset objectAtIndex:0];
            CGFloat newOffsetFloat = newOffset.floatValue + headerHeight + 1;
            NSNumber *finalOffset = [NSNumber numberWithFloat:newOffsetFloat];
            [self.sectionHeaderArray addObject:finalOffset];
            [yOffset replaceObjectAtIndex:0 withObject:finalOffset];
            [yOffset replaceObjectAtIndex:1 withObject:finalOffset];
        }
        if([self.collectionView numberOfItemsInSection:x] == 0){
            self.contentHeight += headerHeight;
        }
        for(int i=0; i<[self.collectionView numberOfItemsInSection:x]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:x];
            CGFloat width;
            int finalWidth;
            if(column == 1){
                width = (self.columnWidth + extra) - (cellPadding * 2);
                finalWidth = self.columnWidth + (self.columnWidth - extra);
            } else {
                width = extra - (cellPadding * 2);
                finalWidth = extra;
            }
            //            CGFloat width = self.columnWidth - (cellPadding * 2);
            CGFloat cellHeight = [self.delegate collectionViewHeightForCellAtIndexPath:indexPath
                                                                                 width:self.columnWidth
                                                                        collectionView:self.collectionView];
            CGFloat height = cellPadding + cellHeight + cellPadding;
            NSNumber *pulledXOffsetNumber = [self.xOffset objectAtIndex:column];
            NSNumber *pulledYOffsetNumber = [yOffset objectAtIndex:column];
            CGFloat pulledXOffset = [pulledXOffsetNumber floatValue];
            CGFloat pulledYOffset = [pulledYOffsetNumber floatValue];
            CGRect frame = CGRectMake(pulledXOffset,
                                      pulledYOffset,
                                      finalWidth,
                                      height);
            CGRect insetFrame = CGRectInset(frame, cellPadding, cellPadding);
            
            PWDiscoverCollageCollectionViewLayoutAttributes *attributes =
            [PWDiscoverCollageCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.cellHeight = cellHeight;
            attributes.frame = insetFrame;
            [self.cache addObject:attributes];
            
            CGFloat maxY = CGRectGetMaxY(frame);
            if(self.contentHeight > maxY){
                self.contentHeight = self.contentHeight;
            } else {
                self.contentHeight = maxY;
            }
            CGFloat yOffsetValueFloat = [[yOffset objectAtIndex:column] floatValue];
            CGFloat newYOffsetValueFloat = yOffsetValueFloat + height;
            NSNumber *newYOffsetValueFloatNumber = [NSNumber numberWithFloat:newYOffsetValueFloat];
            [yOffset replaceObjectAtIndex:column withObject:newYOffsetValueFloatNumber];
            
            if(column >= (numberOfColumns - 1)){
                column = 0;
            } else {
                column = 1+column;
            }
        }
    }
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.contentWidth, self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    for(PWDiscoverCollageCollectionViewLayoutAttributes *attributes in self.cache){
        if(CGRectIntersectsRect(attributes.frame, rect)){
            [layoutAttributes addObject:attributes];
        }
    }
    for(int i=0; i<[self.sectionHeaderArray count]; i++){
        NSNumber *number = [self.sectionHeaderArray objectAtIndex:i];
        float floatValue = number.floatValue - headerHeight;
        PWDiscoverCollageCollectionViewLayoutAttributes *newHeaderAttributes =
        [PWDiscoverCollageCollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                             withIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
        CGRect frame = CGRectMake(0, floatValue, self.collectionView.frame.size.width, headerHeight);
        newHeaderAttributes.frame = frame;
        newHeaderAttributes.zIndex = 1;
        [layoutAttributes addObject:newHeaderAttributes];
    }
    
    return layoutAttributes;
}

+(Class)layoutAttributesClass {
    return [PWDiscoverCollageCollectionViewLayoutAttributes class];
}

@end
