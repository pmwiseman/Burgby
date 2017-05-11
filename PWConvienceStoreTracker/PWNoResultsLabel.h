//
//  PWNoResultsLabel.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PWNoResultsLabelDelegate <UIScrollViewDelegate>
-(void)retryButtonPressed;
@end

@interface PWNoResultsLabel : UILabel

//Delegate
@property (nonatomic, weak) id <PWNoResultsLabelDelegate> delegate;

@end
