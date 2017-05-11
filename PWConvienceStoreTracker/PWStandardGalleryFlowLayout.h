//
//  PWStandardGalleryFlowLayout.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWStandardGalleryFlowLayout : UICollectionViewFlowLayout

+(PWStandardGalleryFlowLayout *)generateStandardPhotoGalleryFlowLayout;
+(PWStandardGalleryFlowLayout *)generateStandardCameraRollFlowLayoutInView:(UIView *)view
                                                        minimumCellSpacing:(int)cellSpacing
                                                    maxNumberOfCellsPerRow:(int)numberPerRow;

@end
