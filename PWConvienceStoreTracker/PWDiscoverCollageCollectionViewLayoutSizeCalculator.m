//
//  PWDiscoverCollageCollectionViewLayoutSizeCalculator.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageCollectionViewLayoutSizeCalculator.h"
#import "PWDiscoverCollageLayoutConfiguration.h"
#import <UIKit/UIKit.h>

@interface PWDiscoverCollageCollectionViewLayoutSizeCalculator ()

@property (strong, nonatomic) PWDiscoverCollageLayoutConfiguration *threeConfiguration;
@property (strong, nonatomic) PWDiscoverCollageLayoutConfiguration *twoConfiguration;
@property (strong, nonatomic) PWDiscoverCollageLayoutConfiguration *fourConfiguration;
@property (strong, nonatomic) PWDiscoverCollageLayoutConfiguration *oneConfiguration;
@property (assign) int itemsToAssign;

@end

@implementation PWDiscoverCollageCollectionViewLayoutSizeCalculator

-(instancetype)init {
    self = [super init];
    if(self) {
        self.threeConfiguration = [[PWDiscoverCollageLayoutConfiguration alloc] initWithConfigurationSize:3];
        self.twoConfiguration = [[PWDiscoverCollageLayoutConfiguration alloc] initWithConfigurationSize:2];
        self.fourConfiguration = [[PWDiscoverCollageLayoutConfiguration alloc] initWithConfigurationSize:4];
        self.oneConfiguration = [[PWDiscoverCollageLayoutConfiguration alloc] initWithConfigurationSize:1];
    }
    return self;
}

-(NSArray *)cellSizesWithTotalNumberOfItems:(int)totalNumberOfItems {
    self.itemsToAssign = totalNumberOfItems;
    NSMutableArray *leftArray = [[NSMutableArray alloc] init];
    NSMutableArray *rightArray = [[NSMutableArray alloc] init];
    if(totalNumberOfItems % 2 == 0){
        NSUInteger lastUsedConfig = 10;
        while (self.itemsToAssign > 0) {
            NSUInteger randomUnsignedInt = arc4random_uniform(2);
            while (lastUsedConfig == randomUnsignedInt) {
                randomUnsignedInt = arc4random_uniform(2);
            }
            if(self.itemsToAssign - 6 >= 0 && randomUnsignedInt == 0){
                for(int i=0; i<2; i++){
                    NSArray *configArray = [self.threeConfiguration getBlockSizesForConfiguration];
                    NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                    NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                    [leftArray addObjectsFromArray:leftArrayObjects];
                    [rightArray addObjectsFromArray:rightArrayObjects];
                }
                self.itemsToAssign -= 6;
                lastUsedConfig = 0;
            } else if(self.itemsToAssign - 4 >= 0 && randomUnsignedInt == 1){
                NSArray *configArray = [self.fourConfiguration getBlockSizesForConfiguration];
                NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                [leftArray addObjectsFromArray:leftArrayObjects];
                [rightArray addObjectsFromArray:rightArrayObjects];
                self.itemsToAssign -= 4;
                lastUsedConfig = 1;
            } else {
                NSArray *configArray = [self.twoConfiguration getBlockSizesForConfiguration];
                NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                [leftArray addObjectsFromArray:leftArrayObjects];
                [rightArray addObjectsFromArray:rightArrayObjects];
                self.itemsToAssign -= 2;
                lastUsedConfig = 2;
            }
        }
        NSArray *array = [[NSArray alloc] initWithObjects:leftArray, rightArray, nil];
        return array;
    } else {
        NSUInteger lastUsedConfig = 10;
        while (self.itemsToAssign > 1) {
            NSUInteger randomUnsignedInt = arc4random_uniform(2);
            while (lastUsedConfig == randomUnsignedInt) {
                randomUnsignedInt = arc4random_uniform(2);
            }
            if(self.itemsToAssign - 6 >= 0 && randomUnsignedInt == 0){
                for(int i=0; i<2; i++){
                    NSArray *configArray = [self.threeConfiguration getBlockSizesForConfiguration];
                    NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                    NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                    [leftArray addObjectsFromArray:leftArrayObjects];
                    [rightArray addObjectsFromArray:rightArrayObjects];
                }
                self.itemsToAssign -= 6;
                lastUsedConfig = 0;
            } else if(self.itemsToAssign - 4 >= 0 && randomUnsignedInt == 1){
                NSArray *configArray = [self.fourConfiguration getBlockSizesForConfiguration];
                NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                [leftArray addObjectsFromArray:leftArrayObjects];
                [rightArray addObjectsFromArray:rightArrayObjects];
                self.itemsToAssign -= 4;
                lastUsedConfig = 1;
            } else {
                NSArray *configArray = [self.twoConfiguration getBlockSizesForConfiguration];
                NSArray *leftArrayObjects = [configArray objectAtIndex:0];
                NSArray *rightArrayObjects = [configArray objectAtIndex:1];
                [leftArray addObjectsFromArray:leftArrayObjects];
                [rightArray addObjectsFromArray:rightArrayObjects];
                self.itemsToAssign -= 2;
                lastUsedConfig = 2;
            }
        }
        NSArray *configArray = [self.oneConfiguration getBlockSizesForConfiguration];
        NSArray *leftArrayObjects = [configArray objectAtIndex:0];
        NSArray *rightArrayObjects = [configArray objectAtIndex:1];
        [leftArray addObjectsFromArray:leftArrayObjects];
        [rightArray addObjectsFromArray:rightArrayObjects];
        self.itemsToAssign -= 1;
        NSArray *array = [[NSArray alloc] initWithObjects:leftArray, rightArray, nil];
        return array;
    }
}

@end
