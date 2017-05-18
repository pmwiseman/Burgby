//
//  PWDiscoverCollageLayoutConfiguration.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverCollageLayoutConfiguration.h"
#import <UIKit/UIKit.h>

@implementation PWDiscoverCollageLayoutConfiguration

#pragma mark - Init Methods
-(instancetype)initWithConfigurationSize:(NSUInteger)configurationSize {
    self = [super init];
    if(self){
        self.configurationSize = configurationSize;
        self.lastUsedConfiguration = 10;
        self.flippedMode = NO;
    }
    return self;
}

-(NSArray *)getBlockSizesForConfiguration {
    NSMutableArray *leftSideConfigurationArray;
    NSMutableArray *rightSideConfigurationArray;
    //Standard Block Sizes
    CGSize largeBlock = CGSizeMake(500, 1000); //2x
    CGSize squareBlock = CGSizeMake(500, 500); //1x
    CGSize mediumBlock = CGSizeMake(500, 750); //1.5
    CGSize smallBlock = CGSizeMake(500, 250); //.5
    //Values
    NSValue *largeBlockValue = [NSValue valueWithCGSize:largeBlock];
    NSValue *squareBlockValue = [NSValue valueWithCGSize:squareBlock];
    NSValue *mediumBlockValue = [NSValue valueWithCGSize:mediumBlock];
    NSValue *smallBlockValue = [NSValue valueWithCGSize:smallBlock];
    //Three Size Configurations
    if(self.configurationSize == 3) {
        BOOL equalConfiguration = YES;
        NSUInteger randomUnsignedInt = 0;
        while (equalConfiguration) {
            randomUnsignedInt = [self rollWithLastUsedConfiguration:self.lastUsedConfiguration numberOfOptions:2];
            if(randomUnsignedInt != self.lastUsedConfiguration){
                equalConfiguration = NO;
                self.lastUsedConfiguration = randomUnsignedInt;
            }
        }
        //1200 and two 600s
        if(randomUnsignedInt == 0){
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //900 and 600 with 300
        } else if(randomUnsignedInt == 1) {
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, smallBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, smallBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //1200 and 900 with 300
        } else {
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
        }
    } else  if(self.configurationSize == 1){
        rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, nil];
        leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, nil];
        NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
        return array;
    } else if(self.configurationSize == 4){
        BOOL equalConfiguration = YES;
        NSUInteger randomUnsignedInt = 0;
        while (equalConfiguration) {
            randomUnsignedInt = [self rollWithLastUsedConfiguration:self.lastUsedConfiguration numberOfOptions:2];
            if(randomUnsignedInt != self.lastUsedConfiguration){
                equalConfiguration = NO;
                self.lastUsedConfiguration = randomUnsignedInt;
            }
        }
        //900 and three 300s
        if (randomUnsignedInt == 4){
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:
                                              smallBlockValue, smallBlockValue, smallBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:
                                               smallBlockValue, smallBlockValue, smallBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //1200 and 600 with two 300s
        } else if (randomUnsignedInt == 5){
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:
                                              squareBlockValue, smallBlockValue, smallBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:
                                               squareBlockValue, smallBlockValue, smallBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //Four 600s
        } else if (randomUnsignedInt == 0){
            rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                
            } else {
                [self toggleFlippedMode:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //900 with 300 and two 600s
        } else if (randomUnsignedInt == 6){
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, squareBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //900 with 300 and 300 with 900
        } else {
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, mediumBlockValue, nil];
            } else {
                [self toggleFlippedMode:YES];
                rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, smallBlockValue, nil];
                leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, mediumBlockValue, nil];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
        }
    }  else {
        BOOL equalConfiguration = YES;
        NSUInteger randomUnsignedInt = 0;
        while (equalConfiguration) {
            randomUnsignedInt = [self rollWithLastUsedConfiguration:self.lastUsedConfiguration numberOfOptions:4];
            if(randomUnsignedInt != self.lastUsedConfiguration){
                equalConfiguration = NO;
                self.lastUsedConfiguration = randomUnsignedInt;
            }
        }
        //300 and 300
        if (randomUnsignedInt == 0){
            leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, nil];
            rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:smallBlockValue, nil];
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                
            } else {
                [self toggleFlippedMode:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //600 and 600
        } else if (randomUnsignedInt == 1){
            leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, nil];
            rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:squareBlockValue, nil];
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                
            } else {
                [self toggleFlippedMode:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //900 and 900
        } else if (randomUnsignedInt == 2){
            leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
            rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:mediumBlockValue, nil];
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                
            } else {
                [self toggleFlippedMode:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
            //1200 and 1200
        } else {
            leftSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
            rightSideConfigurationArray = [[NSMutableArray alloc] initWithObjects:largeBlockValue, nil];
            if(self.flippedMode == YES){
                [self toggleFlippedMode:NO];
                
            } else {
                [self toggleFlippedMode:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:leftSideConfigurationArray, rightSideConfigurationArray, nil];
            return array;
        }
    }
}



#pragma mark - Maintenance
-(void)toggleFlippedMode:(BOOL)flipped {
    self.flippedMode = flipped;
}

-(NSUInteger)rollWithLastUsedConfiguration:(NSUInteger)lastUsedConfiguration
                           numberOfOptions:(NSUInteger)numberOfOptions {
    NSUInteger randomUnsignedInt = arc4random_uniform(numberOfOptions);
    return randomUnsignedInt;
}

@end
