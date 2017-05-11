//
//  PWPhotoGalleryCollectionViewController.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/10/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWPhotoGalleryCollectionViewController.h"
#import "PWPhotoGalleryCollectionViewCell.h"
#import "PWVenuePhotoObject.h"
#import "PWNetworkManager.h"

@interface PWPhotoGalleryCollectionViewController ()

//Paging Setup
@property (assign) int currentPage;
@property (assign) int newPage;
@property (assign) int pageWidth;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;
//Networking
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) NSArray *photoObjectArray;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
//No Results
@property (strong, nonatomic) PWNoResultsLabel *noResultsLabel;

@end

@implementation PWPhotoGalleryCollectionViewController

static NSString * const reuseIdentifier = @"cell";

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self configureNavigationOnLoad];
    [self configureCollectionView];
    [self getVenueImageWithVenueId:self.venueObject];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session invalidateAndCancel];
}

#pragma mark - View Configuration

-(void)configureCollectionView
{
    //Various properties set directly on the collectionView.
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView registerClass:[PWPhotoGalleryCollectionViewCell class]
            forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.pageWidth = self.collectionView.frame.size.width + 15;
    [self configureActivityIndicator];
    [self configureNoResultsLabel];
}

-(void)configureActivityIndicator {
    self.indicatorView = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake(0,
                                          0,
                                          self.view.frame.size.width,
                                          self.view.frame.size.height - 64);
    self.indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.indicatorView];
}

-(void)configureNoResultsLabel {
    self.noResultsLabel = [[PWNoResultsLabel alloc] initWithFrame:self.view.frame];
    self.noResultsLabel.delegate = self;
}

#pragma mark - Navigation Configuration

-(void)configureNavigationOnLoad {
    self.navigationItem.title = @"Photo Gallery";
}

#pragma mark UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoObjectArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PWVenuePhotoObject *object = [self.photoObjectArray objectAtIndex:indexPath.row];
    PWPhotoGalleryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                       forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"Image_Placeholder"];
    cell.imageView.clipsToBounds = YES;
    if(!object.loadedImage){
        [PWNetworkManager loadImageWithUrlString:object.photoUrlString completionBlock:^(UIImage *image) {
            object.loadedImage = image;
            PWPhotoGalleryCollectionViewCell *updateCell = cell;
            if(updateCell){
                dispatch_async(dispatch_get_main_queue(), ^{
                    updateCell.imageView.image = image;
                });
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = object.loadedImage;
        });
    }
    
    return cell;
}

//Set the size of the items within the collectionView.
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.collectionView.frame.size;
}

#pragma mark - Scroll View Delegate Methods

//Method called when the scroll view begins dragging
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.currentPage = floor((self.collectionView.contentOffset.x - self.pageWidth / 2) / self.pageWidth) + 1;
}

//Method called when programmatic scrolling ends
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //Generalized can add buttons
    int currentIndex = self.newPage;
    if(self.currentIndexPath != [NSIndexPath indexPathForItem:currentIndex inSection:0]){
        self.currentIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    }
}

//Method called when user scrolling ends
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //Generalized for scrolling
    int currentIndex = self.newPage;
    if(self.currentIndexPath != [NSIndexPath indexPathForItem:currentIndex inSection:0]){
        self.currentIndexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    }
}

//Method called when the scroll view ends dragging by the user
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.newPage = self.currentPage;
    
    if(velocity.x == 0) {
        self.newPage = floor((targetContentOffset ->x - self.pageWidth / 2) / self.pageWidth) + 1;
    } else {
        if(velocity.x > 0){
            self.newPage = self.currentPage + 1;
        } else {
            self.newPage = self.currentPage - 1;
        }
        if(self.newPage < 0){
            self.newPage = 0;
        }
        if(self.newPage > self.collectionView.contentSize.width / self.pageWidth){
            self.newPage = ceil(self.collectionView.contentSize.width / self.pageWidth) - 1.0;
        }
    }
    
    *targetContentOffset = CGPointMake(self.newPage * self.pageWidth, targetContentOffset ->y);
}

#pragma mark - Networking Calls

-(void)retryButtonPressed {
    [self getVenueImageWithVenueId:self.venueObject];
}

-(void)getVenueImageWithVenueId:(VenueObject *)venue {
    [self.indicatorView startAnimating];
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    [PWNetworkManager getVenueImagesWithVenue:venue
                                      session:self.session
                              completionBlock:^(NSArray *imageUrlStringArray) {
                                  __weak PWPhotoGalleryCollectionViewController *weakself = self;
                                  weakself.photoObjectArray = imageUrlStringArray;
                                  if([weakself.photoObjectArray count] > 0){
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if([weakself.noResultsLabel isDescendantOfView:weakself.view]){
                                              [weakself.noResultsLabel removeFromSuperview];
                                          }
                                          [weakself.indicatorView stopAnimating];
                                          [weakself.collectionView reloadData];
                                      });
                                  } else {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if(![weakself.noResultsLabel isDescendantOfView:weakself.view]){
                                              [weakself.view addSubview:weakself.noResultsLabel];
                                          }
                                          [weakself.indicatorView stopAnimating];
                                      });
                                  }
                              }];
}

@end
