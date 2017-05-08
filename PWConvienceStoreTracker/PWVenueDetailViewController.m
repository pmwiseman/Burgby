//
//  PWVenueDetailViewController.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWVenueDetailViewController.h"
#import "VenueObject.h"
#import "UIColor+Colors.h"
#import "PWNetworkManager.h"
#import "PWVenueDetailActionOptionTableViewCell.h"
#import "PWDetailActionOptionObject.h"
#import "PWSizeCalculator.h"
#import "PWStandardAlerts.h"
@import MapKit;

@interface PWVenueDetailViewController ()

//Scroll View Container
@property (strong, nonatomic) UIScrollView *scrollViewContainer;
//Map View
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) MKPointAnnotation *currentPointAnnotation;
//Image View
@property (strong, nonatomic) UIImageView *imageView;
//Venue Info
@property (strong, nonatomic) UILabel *restaurantNameLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) NSString *formattedDistanceString;
//Action
@property (strong, nonatomic) UITableView *tableView;
//Cells
@property (strong, nonatomic) NSArray *actionCellArray;
//Networking
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) NSString *imageUrlString;

@end

@implementation PWVenueDetailViewController

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";
//View Constants
static int const cellHeight = 65;
static int const distanceLabelHeight = 30;
static NSString * const cellIdentifier = @"cell";

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupCells];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupMapView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getVenuImageWithVenueId:self.venueObject.venueId];
}

#pragma mark - Setup View

-(void)setupCells {
    PWDetailActionOptionObject *directionsActionObject =
    [[PWDetailActionOptionObject alloc] initWithTitle:@"Directions"
                                          imageString:@"Directions_Action_Option_Image"
                                                  tag:0
                                     associatedString:self.venueObject.address];
    PWDetailActionOptionObject *callActionObject =
    [[PWDetailActionOptionObject alloc] initWithTitle:@"Call"
                                          imageString:@"Call_Action_Option_Image"
                                                  tag:1
                                     associatedString:self.venueObject.phoneNumber];
    PWDetailActionOptionObject *websiteActionObject =
    [[PWDetailActionOptionObject alloc] initWithTitle:@"Website"
                                          imageString:@"Website_Action_Option_Image"
                                                  tag:2
                                     associatedString:self.venueObject.website];
    self.actionCellArray = [NSArray arrayWithObjects:directionsActionObject, callActionObject, websiteActionObject, nil];
}

-(void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Info";
    //Scroll View Container
    int scrollViewX = 0;
    int scrollViewY = 0;
    int scrollViewWidth = self.view.frame.size.width;
    int scrollViewHeight = self.view.frame.size.height;
    CGRect scrollViewFrame = CGRectMake(scrollViewX,
                                        scrollViewY,
                                        scrollViewWidth,
                                        scrollViewHeight);
    self.scrollViewContainer = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    [self.view addSubview:self.scrollViewContainer];
    //Image
    int imageViewWidth = self.view.frame.size.width;
    int imageViewHeight = 150;
    int imageViewX = (self.view.frame.size.width - imageViewWidth)/2;
    int imageViewY = 0;
    CGRect imageViewFrame = CGRectMake(imageViewX,
                                       imageViewY,
                                       imageViewWidth,
                                       imageViewHeight);
    self.imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    self.imageView.image = [UIImage imageNamed:@"Image_Placeholder"];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollViewContainer addSubview:self.imageView];
    //Image Overlay
    UIImageView *backgroundImageOverlayView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    backgroundImageOverlayView.image = [UIImage imageNamed:@"Cell_Background_Image_Overlay"];
    backgroundImageOverlayView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageOverlayView.clipsToBounds = YES;
    //        [self.backgroundImageOverlayView setHidden:YES];
    [self.scrollViewContainer addSubview:backgroundImageOverlayView];
    //Venue Name
    CGRect nameTextFrame = [PWSizeCalculator getTextSize:self.venueObject.name
                                                fontSize:22.0
                                            boundingSize:CGSizeMake(self.view.frame.size.width - 16, CGFLOAT_MAX)];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,
                                                               imageViewHeight - nameTextFrame.size.height,
                                                               self.view.frame.size.width - 16,
                                                               nameTextFrame.size.height)];
    nameLabel.numberOfLines = 0;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.font = [UIFont systemFontOfSize:22.0];
    nameLabel.text = self.venueObject.name;
    [self.scrollViewContainer addSubview:nameLabel];
    //Distance Text
    self.formattedDistanceString = [NSString stringWithFormat:@"%@ mi", self.venueObject.distance];
    CGRect formattedDistanceTextFrame = [PWSizeCalculator getTextSize:self.formattedDistanceString
                                                             fontSize:14.0
                                                         boundingSize:CGSizeMake(CGFLOAT_MAX, distanceLabelHeight)];
    int distanceIndicatorViewWidth = distanceLabelHeight + formattedDistanceTextFrame.size.width;
    //Distance Indicator
    UIView *distanceIndicatorView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - distanceIndicatorViewWidth)/2,
                                                                             imageViewY + imageViewHeight + 8,
                                                                             distanceIndicatorViewWidth,
                                                                             distanceLabelHeight)];
    //Image
    UIImageView *distanceIndicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, distanceLabelHeight, distanceLabelHeight)];
    distanceIndicatorImageView.image = [UIImage imageNamed:@"Distance_Indicator_Image"];
    //Distance Label
    self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceLabelHeight,
                                                                   0,
                                                                   formattedDistanceTextFrame.size.width,
                                                                   distanceLabelHeight)];
    self.distanceLabel.font = [UIFont systemFontOfSize:14.0];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    self.distanceLabel.textColor = [UIColor primaryColor];
    self.distanceLabel.text = self.formattedDistanceString;
    [distanceIndicatorView addSubview:self.distanceLabel];
    [distanceIndicatorView addSubview:distanceIndicatorImageView];
    [self.scrollViewContainer addSubview:distanceIndicatorView];
    //Address Label
    //Text Size
    CGRect addressTextFrame = [PWSizeCalculator getTextSize:self.venueObject.address
                                                   fontSize:14.0
                                               boundingSize:CGSizeMake(self.view.frame.size.width - 16,
                                                                       CGFLOAT_MAX)];
    int addressTitleLabelX = 8;
    int addressTitleLabelY = distanceIndicatorView.frame.origin.y + distanceIndicatorView.frame.size.height + 8;
    int addressTitleLabelHeight = addressTextFrame.size.height;
    int addressTitleLabelWidth = self.view.frame.size.width - (addressTitleLabelX * 2);
    CGRect addressTitleLabelFrame = CGRectMake(addressTitleLabelX,
                                              addressTitleLabelY,
                                              addressTitleLabelWidth,
                                              addressTitleLabelHeight);
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:addressTitleLabelFrame];
    addressTitleLabel.numberOfLines = 0;
    addressTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressTitleLabel.text = self.venueObject.address;
    addressTitleLabel.textColor = [UIColor lightGrayColor];
    addressTitleLabel.textAlignment = NSTextAlignmentCenter;
    addressTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.scrollViewContainer addSubview:addressTitleLabel];
    //Table View Top Border
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 addressTitleLabelY + addressTitleLabelHeight + 14,
                                                                 self.view.frame.size.width,
                                                                 1)];
    topBorder.backgroundColor = [UIColor blackColor];
    [self.scrollViewContainer addSubview:topBorder];
    //Table View
    int standardCellHeight = 65;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   topBorder.frame.origin.y + 1,
                                                                   self.view.frame.size.height,
                                                                   standardCellHeight * 3)
                                                  style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[PWVenueDetailActionOptionTableViewCell class]
           forCellReuseIdentifier:cellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.scrollViewContainer addSubview:self.tableView];
}

-(void)setupMapView
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //Map
//        int mapViewX = 0;
//        int mapViewY = 202;
//        int mapViewWidth = self.view.frame.size.width;
//        int mapViewHeight = 150;
//        CGRect mapViewFrame = CGRectMake(mapViewX,
//                                         mapViewY,
//                                         mapViewWidth,
//                                         mapViewHeight);
//        self.mapView = [[MKMapView alloc] initWithFrame:mapViewFrame];
//        self.mapView.zoomEnabled = YES;
//        [self.scrollViewContainer addSubview:self.mapView];
//        [self.scrollViewContainer bringSubviewToFront:self.mapView];
//        CLLocationCoordinate2D coordinate =
//        CLLocationCoordinate2DMake(self.venueObject.latitude,
//                                   self.venueObject.longitude);
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.02f, 0.02f);
//        MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
//        self.mapView.region = region;
//        //Add annotation
//        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
//        pointAnnotation.coordinate = coordinate;
//        pointAnnotation.title = @"Current Location";
//        [self.mapView addAnnotation:pointAnnotation];
//    });
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Option Actions

-(void)callPhoneWithNumber:(NSString *)number
{
    if(number.length > 0){
        UIAlertController *alert =[PWStandardAlerts callPhoneConfirmationWithNumber:number];
        UIAlertAction *callNumber = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@"+ -"];
            NSString *numberToCall = [[number componentsSeparatedByCharactersInSet:charsToRemove] componentsJoinedByString:@""];
            NSString *numberToCallFixed = [NSString stringWithFormat:@"tel://%@", numberToCall];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:numberToCallFixed]];
        }];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:callNumber];
        [alert addAction:dismissAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    } else {
        UIAlertController *alert = [PWStandardAlerts noPhoneNumberAvailable];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:dismissAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}

-(void)openWebpageWithUrlString:(NSString *)urlString
{
    if(urlString.length > 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    } else {
        UIAlertController *alert = [PWStandardAlerts noWebpageAvailable];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:dismissAction];
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

//Method to open directions to the identified restaurant in apple maps
-(void)openDirectionsInAppleMaps
{
    NSString *newString = [self.venueObject.address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if(![CLLocationManager locationServicesEnabled]){
        NSString *addressString = [NSString stringWithFormat:@"http://maps.apple.com/?address=%@", newString];
        NSURL *url = [NSURL URLWithString:addressString];
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSString *addressString = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=Current%%20Location", newString];
        NSURL *url = [NSURL URLWithString:addressString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - UITableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.actionCellArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PWDetailActionOptionObject *object = [self.actionCellArray objectAtIndex:indexPath.row];
    PWVenueDetailActionOptionTableViewCell *cell =
    [[PWVenueDetailActionOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier
                                                       cellHeight:cellHeight
                                                        cellWidth:self.view.frame.size.width];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.actionOptionLabel.text = object.title;
    cell.actionOptionImageView.image = object.image;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PWDetailActionOptionObject *object = [self.actionCellArray objectAtIndex:indexPath.row];
    switch (object.tag) {
        case 0:
            [self openDirectionsInAppleMaps];
            break;
        case 1:
            [self callPhoneWithNumber:self.venueObject.phoneNumber];
            break;
        case 2:
            [self openWebpageWithUrlString:self.venueObject.website];
            break;
        default:
            break;
    }
}

#pragma mark - Networking Calls

-(void)getVenuImageWithVenueId:(NSString *)venueId {
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    [PWNetworkManager getVenueImagesWithVenue:self.venueObject
                                      session:self.session
                              completionBlock:^(NSString *imageUrlString) {
        self.imageUrlString = imageUrlString;
        if(![self.imageUrlString isEqualToString:@"no image"]){
            [PWNetworkManager loadImageWithUrlString:self.imageUrlString completionBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = image;
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageNamed:@"No_Image"];
            });
        }
    }];
}

@end
