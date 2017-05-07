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
@property (strong, nonatomic) UIButton *directionsButton;
@property (strong, nonatomic) UILabel *phoneNumberLabel;
@property (strong, nonatomic) UILabel *websiteLabel;
@property (strong, nonatomic) UITextView *callPhoneNumberTextView;
@property (strong, nonatomic) UITextView *websiteTextView;
//Networking
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
@property (strong, nonatomic) NSString *imageUrlString;

@end

@implementation PWVenueDetailViewController

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    if(self.venueObject.phoneNumber.length > 0){
        self.callPhoneNumberTextView.text = self.venueObject.phoneNumber;
    } else {
        self.callPhoneNumberTextView.text = @"N/A";
    }
    //Website
    if(self.venueObject.website.length > 0){
        self.websiteTextView.text = self.venueObject.website;
    } else {
        self.websiteTextView.text = @"N/A";
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupMapView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getVenueImageWithVenueId:self.venueObject.venueId];
}

#pragma mark - Setup View

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
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollViewContainer addSubview:self.imageView];
    //Restaurant Name
    int restaurantNameWidth = imageViewWidth - 16;
    int restaurantNameHeight = 100;
    int restaurantNameX = 8;
    int restaurantNameY = imageViewHeight - restaurantNameHeight;
    CGRect restaurantNameFrame = CGRectMake(restaurantNameX,
                                            restaurantNameY,
                                            restaurantNameWidth,
                                            restaurantNameHeight);
    self.restaurantNameLabel = [[UILabel alloc] initWithFrame:restaurantNameFrame];
    self.restaurantNameLabel.text = self.venueObject.name;
    self.restaurantNameLabel.numberOfLines = 0;
    self.restaurantNameLabel.textAlignment = NSTextAlignmentLeft;
    self.restaurantNameLabel.font = [UIFont boldSystemFontOfSize:24.0];
    self.restaurantNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.restaurantNameLabel sizeToFit];
    CGRect adjustmentFrame = self.restaurantNameLabel.frame;
    adjustmentFrame.origin.y = imageViewHeight - adjustmentFrame.size.height - 8;
    self.restaurantNameLabel.frame = adjustmentFrame;
    [self.imageView addSubview:self.restaurantNameLabel];
    //Gradient image
    int gradientX = 0;
    int gradientWidth = self.view.frame.size.width;
    int gradientHeight = self.restaurantNameLabel.frame.size.height + 10;
    int gradientY = imageViewHeight - gradientHeight;
    CGRect gradientFrame = CGRectMake(gradientX,
                                      gradientY,
                                      gradientWidth,
                                      gradientHeight);
    UIImageView *gradientImageView = [[UIImageView alloc] initWithFrame:gradientFrame];
    gradientImageView.image = [UIImage imageNamed:@"White_Gradient"];
    [self.imageView addSubview:gradientImageView];
    [self.imageView sendSubviewToBack:gradientImageView];
    //Phone Number Label
    int addressTitleLabelX = 8;
    int addressTitleLabelY = imageViewY + imageViewHeight;
    int addressTitleLabelHeight = 25;
    int addressTitleLabelWidth = 200;
    CGRect addressTitleLabelFrame = CGRectMake(addressTitleLabelX,
                                              addressTitleLabelY,
                                              addressTitleLabelWidth,
                                              addressTitleLabelHeight);
    UILabel *addressTitleLabel = [[UILabel alloc] initWithFrame:addressTitleLabelFrame];
    addressTitleLabel.text = @"Address";
    addressTitleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.scrollViewContainer addSubview:addressTitleLabel];
    //Address info
    int addressInfoX = 8;
    int addressInfoY = addressTitleLabelY + addressTitleLabelHeight;
    int addressInfoWidth = 300;
    int addressInfoHeight = 25;
    CGRect addressInfoFrame = CGRectMake(addressInfoX,
                                         addressInfoY,
                                         addressInfoWidth,
                                         addressInfoHeight);
    self.addressLabel = [[UILabel alloc] initWithFrame:addressInfoFrame];
    self.addressLabel.font = [UIFont systemFontOfSize:11.0];
    self.addressLabel.textColor = [UIColor blackColor];
    self.addressLabel.text = self.venueObject.simplifiedAddress;
    [self.scrollViewContainer addSubview:self.addressLabel];
    //Directions Button
    int directionsButtonWidth = 100;
    int directionsButtonHeight = 25;
    int directionsButtonX = self.view.frame.size.width - directionsButtonWidth - 8;
    int directionsButtonY = addressInfoY;
    CGRect directionsButtonFrame = CGRectMake(directionsButtonX,
                                           directionsButtonY,
                                           directionsButtonWidth,
                                           directionsButtonHeight);
    self.directionsButton = [[UIButton alloc] initWithFrame:directionsButtonFrame];
    [self.directionsButton setTitle:@"Directions" forState:UIControlStateNormal];
    [self.directionsButton setTitleColor:[UIColor peterRiverColor] forState:UIControlStateNormal];
    self.directionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.directionsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.directionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
    [self.directionsButton addTarget:self
                              action:@selector(openDirectionsInAppleMaps)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewContainer addSubview:self.directionsButton];
    //Phone Number Label
    int phoneNumberLabelX = 8;
    int phoneNumberLabelY = addressInfoY + addressInfoHeight + 154;
    int phoneNumberLabelHeight = 25;
    int phoneNumberLabelWidth = 150;
    CGRect phoneNumberLabelFrame = CGRectMake(phoneNumberLabelX,
                                              phoneNumberLabelY,
                                              phoneNumberLabelWidth,
                                              phoneNumberLabelHeight);
    self.phoneNumberLabel = [[UILabel alloc] initWithFrame:phoneNumberLabelFrame];
    self.phoneNumberLabel.text = @"Phone";
    self.phoneNumberLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.scrollViewContainer addSubview:self.phoneNumberLabel];
    //Call Phone Number Text View
    int callPhoneTextViewWidth = 200;
    int callPhoneTextViewHeight = 25;
    int callPhoneTextViewX = 8;
    int callPhoneTextViewY = phoneNumberLabelY + phoneNumberLabelHeight;
    CGRect callPhoneButtonFrame = CGRectMake(callPhoneTextViewX,
                                             callPhoneTextViewY,
                                             callPhoneTextViewWidth,
                                             callPhoneTextViewHeight);
    self.callPhoneNumberTextView = [[UITextView alloc] initWithFrame:callPhoneButtonFrame];
    self.callPhoneNumberTextView.textAlignment = NSTextAlignmentLeft;
    self.callPhoneNumberTextView.tintColor = [UIColor peterRiverColor];
    self.callPhoneNumberTextView.font = [UIFont systemFontOfSize:14.0];
     self.callPhoneNumberTextView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    self.callPhoneNumberTextView.editable = NO;
    [self.scrollViewContainer addSubview:self.callPhoneNumberTextView];
    //Website Label
    int websiteLabelX = 8;
    int websiteLabelY = callPhoneTextViewY + callPhoneTextViewHeight + 8;
    int websiteLabelHeight = 25;
    int websiteLabelWidth = 90;
    CGRect websiteLabelFrame = CGRectMake(websiteLabelX,
                                          websiteLabelY,
                                          websiteLabelWidth,
                                          websiteLabelHeight);
    self.websiteLabel = [[UILabel alloc] initWithFrame:websiteLabelFrame];
    self.websiteLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.websiteLabel.text = @"Website";
    [self.scrollViewContainer addSubview:self.websiteLabel];
    //Website Text View
    int websiteTextViewWidth = 300;
    int websiteTextViewHeight = 25;
    int websiteTextViewX = 8;
    int websiteTextViewY = websiteLabelY + websiteLabelHeight;
    CGRect websiteTextViewFrame = CGRectMake(websiteTextViewX,
                                             websiteTextViewY,
                                             websiteTextViewWidth,
                                             websiteTextViewHeight);
    self.websiteTextView = [[UITextView alloc] initWithFrame:websiteTextViewFrame];
    self.websiteTextView.textAlignment = NSTextAlignmentLeft;
    self.websiteTextView.tintColor = [UIColor peterRiverColor];
    self.websiteTextView.font = [UIFont systemFontOfSize:14.0];
    self.websiteTextView.editable = NO;
    self.websiteTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.scrollViewContainer addSubview:self.websiteTextView];
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

#pragma mark - Apple Maps

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

#pragma mark - Networking Calls

-(void)getVenueImageWithVenueId:(NSString *)venueId
{
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *fourSquareDataUrlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=20160406",venueId,clientId, clientSecret];
    if(!self.session){
        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
                                                     delegate:self
                                                delegateQueue:nil];
    }
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[NSURL URLWithString:fourSquareDataUrlString] completionHandler:^(NSData * _Nullable data,
                            NSURLResponse * _Nullable response,
                            NSError * _Nullable error) {
        if(!error){
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
            if(urlResponse.statusCode == 200){
                NSError *jsonError;
                NSDictionary *responseObject =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                  error:&jsonError];
                if(!jsonError){
                    NSDictionary *responseDictionary = responseObject[@"response"];
                    NSArray *photoArray = [responseDictionary valueForKeyPath:@"photos.items"];
                    if([photoArray count] > 0){
                        NSDictionary *dictionary = [photoArray objectAtIndex:0];
                        NSString *prefixString = dictionary[@"prefix"];
                        NSString *suffixString = dictionary[@"suffix"];
                        NSNumber *width = dictionary[@"width"];
                        NSNumber *height = dictionary[@"height"];
                        NSString  *widthString = [NSString stringWithFormat:@"%@", width];
                        NSString  *heightString = [NSString stringWithFormat:@"%@", height];
                        self.imageUrlString = [NSString stringWithFormat:@"%@%@x%@%@", prefixString, widthString, heightString, suffixString];
                    } else {
                        self.imageUrlString = @"no image";
                    }
                }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        if(![self.imageUrlString isEqualToString:@"no image"]){
                            self.imageView.image =
                            [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]]];
                        } else {
                            self.imageView.image = [UIImage imageNamed:@"Burgers_Nearby_No_Image_Available"];
                        }
                    });
            }
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    [dataTask resume];
}

@end
