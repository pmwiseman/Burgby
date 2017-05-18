//
//  PWDiscoverCollageLayoutConfiguration.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWDiscoverCollageLayoutConfiguration : NSObject

@property (assign) NSUInteger lastUsedConfiguration;
@property (assign) BOOL flippedMode;
@property (assign) NSUInteger configurationSize;

-(instancetype)initWithConfigurationSize:(NSUInteger)configurationSize;
-(NSArray *)getBlockSizesForConfiguration;

@end
