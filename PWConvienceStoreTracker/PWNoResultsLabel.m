//
//  PWNoResultsLabel.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWNoResultsLabel.h"

@implementation PWNoResultsLabel

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.text = @"No Results, Tap to Retry.";
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor blackColor];
        //retry button
        UIButton *retryButton = [[UIButton alloc] initWithFrame:frame];
        retryButton.backgroundColor = [UIColor clearColor];
        [retryButton addTarget:self
                        action:@selector(retryAction)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:retryButton];
    }
    return self;
}

-(void)retryAction {
    [self.delegate retryButtonPressed];
}

@end
