//
//  PWDiscoverCollageCollectionViewLayout.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol declaration
@protocol PWDiscoverCollageCollectionViewLayoutDelegate <NSObject>
-(CGFloat)collectionViewHeightForCellAtIndexPath:(NSIndexPath *)indexPath
                                           width:(CGFloat)width
                                  collectionView:(UICollectionView *)collectionView;
@end

@interface PWDiscoverCollageCollectionViewLayout : UICollectionViewLayout

//Properties
@property (assign) id <PWDiscoverCollageCollectionViewLayoutDelegate> delegate;
@property (assign) NSUInteger headerHeight;

@end
