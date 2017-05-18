//
//  PWDiscoverViewController.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/15/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWDiscoverViewController.h"
#import "PWDiscoverCollageCollectionViewLayoutSizeCalculator.h"
#import "UIColor+Colors.h"
#import <AVFoundation/AVFoundation.h>
#import "PWDiscoverCollageCollectionViewCell.h"

@interface PWDiscoverViewController ()

@property (strong, nonatomic) NSMutableArray *configurationArray;
@property (assign) NSUInteger leftSideIndex;
@property (assign) NSUInteger rightSideIndex;
@property (strong, nonatomic) NSMutableArray *setConfigurationArray;
@property (strong, nonatomic) UIBarButtonItem *showMenuTableViewButton;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (assign) BOOL loadAttempted;
@property (strong, nonatomic) NSMutableArray *discoverVenueArray;

@end

@implementation PWDiscoverViewController

static NSString * const reuseIdentifier = @"cell";
static NSString * const headerReuseIdentifier = @"headerCell";
static NSString * const userThumbnailImagePlaceHolderString = @"placeholder";
static NSString * const reviewThumbnailImagePlaceHolderString = @"Gray_Image";

#pragma mark - View Controller Lifecycle

//TODO: Clean up, make more modular.  Can easily be refactored.
//TODO: Try and move out size calculation methods, more abstract.

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupIndicator];
    self.discoverVenueArray = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"1", @"2", @"3", @"4", @"5", nil];
    if([self.discoverVenueArray count] > 0){
        self.leftSideIndex = 0;
        self.rightSideIndex = 0;
        self.configurationArray = [[NSMutableArray alloc] init];
        PWDiscoverCollageCollectionViewLayoutSizeCalculator *calc =
        [[PWDiscoverCollageCollectionViewLayoutSizeCalculator alloc] init];
        int headerSectionInfo = 0;
        NSArray *configArray = [calc cellSizesWithTotalNumberOfItems:(int)[self.discoverVenueArray count]];
        NSArray *leftConfigurationArray = [configArray objectAtIndex:0];
        leftConfigurationArray = [self returnShuffledArray:leftConfigurationArray];
        NSArray *rightConfigurationArray = [configArray objectAtIndex:1];
        rightConfigurationArray = [self returnShuffledArray:rightConfigurationArray];
        NSArray *leftAndRightConfigurations = [NSArray arrayWithObjects:leftConfigurationArray, rightConfigurationArray, nil];
        [self.configurationArray addObject:leftAndRightConfigurations];
        headerSectionInfo++;
    }
    self.navigationItem.title = @"Discover";
    PWDiscoverCollageCollectionViewLayout *layout =
    (PWDiscoverCollageCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[PWDiscoverCollageCollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Navigation

-(void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View Setup

-(void)setupIndicator {
    //Load Indicator
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height);
    [self.indicatorView setHidesWhenStopped:YES];
    [self.view addSubview:self.indicatorView];
}

#pragma mark - Data Handling

-(NSArray *)returnShuffledArray:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:array];
    for(int i=0; i<[array count]/2; i++){
        int randomNumOne = (int)arc4random_uniform((uint32_t)[array count]-1);
        int randomNumTwo = (int)arc4random_uniform((uint32_t)[array count]-1);
        [mutableArray exchangeObjectAtIndex:randomNumOne withObjectAtIndex:randomNumTwo];
    }
    array = mutableArray;
    return array;
}

#pragma mark UICollectionViewDataSource

- (CGSize) blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0)
        return CGSizeMake(2, 1);
    
    return CGSizeMake(1, 2);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.discoverVenueArray count] > 0){
        return [self.discoverVenueArray count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWDiscoverCollageCollectionViewCell *cell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:@"cell"
                                                 forIndexPath:indexPath];
    if(indexPath.row %2){
        cell.backgroundColor = [UIColor blueColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

#pragma mark - Custom Collection View Layout Delegate

-(CGFloat)collectionViewHeightForCellAtIndexPath:(NSIndexPath *)indexPath
                                           width:(CGFloat)width
                                  collectionView:(UICollectionView *)collectionView {
    CGRect boundingRect = CGRectMake(0, 0, width, CGFLOAT_MAX);
    //Back Up Values
    CGSize squareBlock = CGSizeMake(500, 500);
    //Values
    NSValue *squareBlockValue = [NSValue valueWithCGSize:squareBlock];
    NSValue *value;
    NSArray *leftAndRightConfigurations = [self.configurationArray objectAtIndex:indexPath.section];
    NSArray *leftConfigurationArray = [leftAndRightConfigurations objectAtIndex:0];
    NSArray *rightConfigurationArray = [leftAndRightConfigurations objectAtIndex:1];
    if([self.setConfigurationArray count] < [self.configurationArray count]){
        if(!self.setConfigurationArray){
            self.setConfigurationArray = [[NSMutableArray alloc] init];
        }
        if(indexPath.row == 0 || indexPath.row % 2 == 0){
            if(self.leftSideIndex < [leftConfigurationArray count]){
                value = [leftConfigurationArray objectAtIndex:self.leftSideIndex];
                self.leftSideIndex++;
                if(self.leftSideIndex == [leftConfigurationArray count]){
                    self.leftSideIndex = 0;
                }
            } else {
                if(self.rightSideIndex < [rightConfigurationArray count]){
                    value = [rightConfigurationArray objectAtIndex:self.rightSideIndex];
                    self.rightSideIndex++;
                    if(self.rightSideIndex == [rightConfigurationArray count]){
                        self.rightSideIndex = 0;
                    }
                }else {
                    value = squareBlockValue;
                    [self.setConfigurationArray insertObject:value atIndex:indexPath.row];
                }
            }
        } else {
            if(self.rightSideIndex < [rightConfigurationArray count]){
                value = [rightConfigurationArray objectAtIndex:self.rightSideIndex];
                self.rightSideIndex++;
                if(self.rightSideIndex == [rightConfigurationArray count]){
                    self.rightSideIndex = 0;
                }
            } else {
                if(self.leftSideIndex < [leftConfigurationArray count]){
                    value = [leftConfigurationArray objectAtIndex:self.leftSideIndex];
                    self.leftSideIndex++;
                    if(self.leftSideIndex == [leftConfigurationArray count]){
                        self.leftSideIndex = 0;
                    }
                } else {
                    value = squareBlockValue;
                }
            }
        }
    } else {
        value = [self.setConfigurationArray objectAtIndex:indexPath.row];
    }
    CGSize fakeImageSize = [value CGSizeValue];
    CGRect rect = AVMakeRectWithAspectRatioInsideRect(fakeImageSize, boundingRect);
    return rect.size.height + 70;
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath {
    PWDiscoverCollageCollectionViewCell *myCell = (PWDiscoverCollageCollectionViewCell *)cell;
    CGRect newFrame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    myCell.pictureImageView.frame =  newFrame;
    myCell.collageCellView.frame = CGRectMake(0, cell.frame.size.height/2, cell.frame.size.width, cell.frame.size.height/2);
    myCell.collageCellView.dishNameLabel.frame = CGRectMake(0,
                                                            0,
                                                            myCell.collageCellView.frame.size.width,
                                                            myCell.collageCellView.frame.size.height);
    myCell.collageCellView.gradientImageView.frame = CGRectMake(0,
                                                                0,
                                                                myCell.collageCellView.frame.size.width,
                                                                myCell.collageCellView.frame.size.height);
    if(myCell.frame.size.height > 260 && myCell.frame.size.width > self.view.frame.size.width/2){
        myCell.collageCellView.dishNameLabel.font = [UIFont systemFontOfSize:34.0];
    } else if(myCell.frame.size.height > 220 && myCell.frame.size.width > self.view.frame.size.width/2){
        myCell.collageCellView.dishNameLabel.font = [UIFont systemFontOfSize:22.0];
    } else {
        myCell.collageCellView.dishNameLabel.font = [UIFont systemFontOfSize:14.0];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dictionary = [self.itemArray objectAtIndex:indexPath.section];
//    NSMutableArray *array = [dictionary objectForKey:@"dishArray"];
//    DishObject *object = [array objectAtIndex:indexPath.row];
//    PremiumMenuItemViewController *menuItemViewController = [[PremiumMenuItemViewController alloc] init];
//    menuItemViewController.dishObject = object;
//    [self.navigationController pushViewController:menuItemViewController animated:YES];
}

-(UIFont *)getFontForCollageViewDishNameLabelText:(UILabel *)label
                                        container:(CGRect)frame {
    if((frame.size.height > 260 && frame.size.width > self.view.frame.size.width/2) || frame.size.width > self.view.frame.size.width - 20){
        return [UIFont systemFontOfSize:34.0];
    } else if(frame.size.height > 220 && frame.size.width > self.view.frame.size.width/2){
        return [UIFont systemFontOfSize:22.0];
    } else {
        return [UIFont systemFontOfSize:14.0];
    }
}

#pragma mark - Networking


@end

