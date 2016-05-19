//
//  PWPrimaryViewController.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/6/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWPrimaryViewController.h"
#import "PWVenueCell.h"
#import "VenueObject.h"
#import "PWVenueDetailViewController.h"
#import "UIColor+Colors.h"
#import "PWSearchTextFieldView.h"

@interface PWPrimaryViewController ()

//Table View
@property (strong, nonatomic) VenueObject *venueObject;
@property (strong, nonatomic) PWVenueCell *cell;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) PWSearchTextFieldView *searchBar;
@property (strong, nonatomic) PWSearchTextFieldView *locationSearchBar;
@property (strong, nonatomic) UILabel *noResultsLabel;
//Networking
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionConfiguration *sessionConfiguration;
//Data
@property (strong, nonatomic) NSMutableArray *venueList;
//Location
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign) int previousStatusValue;

@end

@implementation PWPrimaryViewController

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";
//View
static NSString * const cellIdentifier = @"cellIdentifier";
static int const navBarPlusStatusBar = 64;

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.venueList = [[NSMutableArray alloc] init];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    [self.navigationItem setTitle:@"Discover"];
    [self setupTableView];
    [self getCurrentLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - View Setup

-(void)setupTableView
{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    int tableViewX = 0;
    int tableViewY = 75;
    int tableViewWidth = self.view.frame.size.width;
    int tableViewHeight = self.view.frame.size.height - tableViewY - navBarPlusStatusBar;
    CGRect tableViewFrame = CGRectMake(tableViewX,
                                       tableViewY,
                                       tableViewWidth,
                                       tableViewHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[PWVenueCell class]
           forCellReuseIdentifier:cellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getNearbyFood)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    //Search Bar
    int searchBarX = 0;
    int searchBarY = 0;
    int searchBarWidth = self.view.frame.size.width;
    int searchBarHeight = 40;
    CGRect searchBarFrame = CGRectMake(searchBarX,
                                       searchBarY,
                                       searchBarWidth,
                                       searchBarHeight);
    self.searchBar = [[PWSearchTextFieldView alloc] initWithFrame:searchBarFrame];
    [self.searchBar setStandardPlaceholderWithText:@"Type of food, etc..."];
    self.searchBar.textField.delegate = self;
    self.searchBar.textField.tag = 0;
    //[self.searchBar setBackgroundImage:[UIImage imageNamed:@"Burgers_Nav_Bar_Color"]];
    [self.view addSubview:self.searchBar];
    //Location Search Bar
    int locationSearchBarX = 0;
    int locationSearchBarY = 35;
    int locationSearchBarWidth = self.view.frame.size.width;
    int locationSearchBarHeight = 40;
    CGRect locationSearchBarFrame = CGRectMake(locationSearchBarX,
                                               locationSearchBarY,
                                               locationSearchBarWidth,
                                               locationSearchBarHeight);
    self.locationSearchBar = [[PWSearchTextFieldView alloc] initWithFrame:locationSearchBarFrame];
    self.locationSearchBar.locationMode = YES;
    [self.locationSearchBar setStandardPlaceholderWithText:@"Location"];
    self.locationSearchBar.textField.delegate = self;
    self.locationSearchBar.textField.tag = 1;
    //[self.locationSearchBar setBackgroundImage:[UIImage imageNamed:@"Burgers_Nav_Bar_Color"]];
    [self.view addSubview:self.locationSearchBar];
    //No Results Label
    int noResultsLabelX = 0;
    int noResultsLabelY = 0;
    int noResultsLabelWidth = self.view.frame.size.width;
    int noResultsLabelHeight = self.view.frame.size.height;
    CGRect noResultsLabelFrame = CGRectMake(noResultsLabelX,
                                            noResultsLabelY,
                                            noResultsLabelWidth,
                                            noResultsLabelHeight);
    self.noResultsLabel = [[UILabel alloc] initWithFrame:noResultsLabelFrame];
    self.noResultsLabel.text = @"No Results";
    self.noResultsLabel.textColor = [UIColor lightGrayColor];
    self.noResultsLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.noResultsLabel.textAlignment = NSTextAlignmentCenter;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if([self.venueList count] > 0){
        if([self.noResultsLabel isDescendantOfView:self.tableView]){
            [self.noResultsLabel removeFromSuperview];
            
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        count = [self.venueList count];
    } else {
        count = 0;
        if(![self.noResultsLabel isDescendantOfView:self.tableView]){
            self.tableView.backgroundView = self.noResultsLabel;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.venueObject = [self.venueList objectAtIndex:indexPath.row];
    CGSize tempRestaurantNameSize = [self.venueObject.name sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
    if(tempRestaurantNameSize.width > 270){
        self.cell = [[PWVenueCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier
                                            nameHeight:44];
    } else {
        self.cell = [[PWVenueCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:cellIdentifier
                                            nameHeight:20];
    }
    self.cell.nameLabel.text = self.venueObject.name;
    self.cell.addressTextView.text = self.venueObject.address;
    if([self.locationSearchBar.textField.text isEqualToString:@"Current Location"]){
        if([self.cell.distanceLabel isHidden]){
            [self.cell.distanceLabel setHighlighted:YES];
        }
        self.cell.distanceLabel.text = [NSString stringWithFormat:@"%@mi", self.venueObject.distance];
    } else {
        [self.cell.distanceLabel setHidden:YES];
    }
    
    
    return self.cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueObject *object = [self.venueList objectAtIndex:indexPath.row];
    CGSize tempRestaurantNameSize = [object.name sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
    int height;
    if(tempRestaurantNameSize.width > 270){
        height = 94;
    } else {
        height = 70;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VenueObject *object = [self.venueList objectAtIndex:indexPath.row];
    PWVenueDetailViewController *venueDetailViewController = [[PWVenueDetailViewController alloc] init];
    venueDetailViewController.venueObject = object;
    if([self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:venueDetailViewController animated:YES];
}

#pragma mark - UITextView Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //food search bar
    if([self.searchBar.textField isFirstResponder]){
        [self.searchBar hideStandardPlaceholder];
    }
    //location search search bar
    if([self.locationSearchBar.textField isFirstResponder]){
        [self.locationSearchBar hideStandardPlaceholder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //food search bar
    if([self.searchBar.textField isFirstResponder]){
        [self.searchBar.textField resignFirstResponder];
    }
    //location search search bar
    if([self.locationSearchBar.textField isFirstResponder]){
        [self.locationSearchBar.textField resignFirstResponder];
    }
    [self getNearbyFood];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //food search bar
    if(textField.tag == 0
       && [self.searchBar.textField.text isEqualToString:@""]){
        [self.searchBar setStandardPlaceholderWithText:@"Type of food, etc..."];
    }
    //location search search bar
    if(textField.tag == 1
       && [self.locationSearchBar.textField.text isEqualToString:@""]){
        [self.locationSearchBar setStandardPlaceholderWithText:@"Location"];
    }
}

#pragma mark - Location

//Get the current user location
-(void)getCurrentLocation
{
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    self.previousStatusValue = [CLLocationManager authorizationStatus];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    } else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted
              && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        self.geoCoder = [[CLGeocoder alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100.0f;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == 3 || status == 4 || status == 5){
        if(self.previousStatusValue == 0){
            [self getCurrentLocation];
        }
    } else  if(status == 1 || status == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Error"
                                                                       message:@"Location Services are disabled go to Settings > Privacy > Location Services > PWPrimaryMapViewController and tap While Using"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:dismissAction];
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

//Current user location returned
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //Set the current region
    self.currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    //Get nearby
    [self getNearbyFood];
}

//Current user location not returned
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Error"
                                                                   message:@"Location Services are disabled or a network connection is not available"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:dismissAction];
    [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Networking Calls

-(void)getNearbyFood
{
    if(![self.refreshControl isRefreshing]){
        [self.tableView setContentOffset:CGPointMake(0, -64) animated:YES];
        [self.refreshControl beginRefreshing];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    NSString *text;
    if(self.searchBar.textField.text.length == 0){
        text = @"burgers";
    } else {
        text = [self.searchBar.textField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *fourSquareDataUrlString;
    if([self.locationSearchBar.textField.text isEqualToString:@"Current Location"]){
        fourSquareDataUrlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%f,%f&query=%@",
                                             clientId,
                                             clientSecret,
                                             self.currentLocation.coordinate.latitude,
                                             self.currentLocation.coordinate.longitude,
                                             text];
    } else {
        fourSquareDataUrlString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&near=%@&query=%@",
                                   clientId,
                                   clientSecret,
                                   self.locationSearchBar.textField.text,
                                   text];
    }
    
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
                NSMutableArray *returnedResults = [[NSMutableArray alloc] init];
                if(!jsonError){
                    NSDictionary *responseDictionary = responseObject[@"response"];
                    NSArray *venuesArray = responseDictionary[@"venues"];
                    for(NSDictionary *dictionary in venuesArray){
                        //Lat and Lon
                        NSString *tempLat = [dictionary valueForKeyPath:@"location.lat"];
                        NSString *tempLon = [dictionary valueForKeyPath:@"location.lng"];
                        float lat = (CGFloat)[tempLat floatValue];
                        float lon = (CGFloat)[tempLon floatValue];
                        //Address
                        NSArray *addressArray = [dictionary valueForKeyPath:@"location.formattedAddress"];
                        NSString *addressString;
                        if([addressArray count] == 2){
                            addressString = [NSString stringWithFormat:@"%@, %@", addressArray[0], addressArray[1]];
                        } else {
                            addressString = [NSString stringWithFormat:@"%@, %@, %@", addressArray[0], addressArray[1], addressArray[2]];
                        }
                        CLLocation *currentLocation =
                        [[CLLocation alloc] initWithLatitude:self.currentLocation.coordinate.latitude
                                                   longitude:self.currentLocation.coordinate.longitude];
                        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
                        CLLocationDistance distance = [venueLocation distanceFromLocation:currentLocation];
                        NSString *distanceString = [NSString stringWithFormat:@"%.02f", distance/1609.34];
                        VenueObject *venueObject =
                        [[VenueObject alloc] initWithLatitude:lat
                                                    longitude:lon
                                                         name:dictionary[@"name"]
                                                      address:addressString
                                                     distance:distanceString
                                            simplifiedAddress:addressArray[0]
                                                      venueId:dictionary[@"id"]
                                                  phoneNumber:[dictionary valueForKeyPath:@"contact.formattedPhone"]
                                                      website:dictionary[@"url"]];
                        [returnedResults addObject:venueObject];
                    }
                    self.venueList = returnedResults;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        if([self.refreshControl isRefreshing]){
                            [self.refreshControl endRefreshing];
                        }
                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                        [self.tableView reloadData];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    if([self.refreshControl isRefreshing]){
                        [self.refreshControl endRefreshing];
                    }
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                                   message:@"Check to make sure that your location services are on and you are connected to a network"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:dismissAction];
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if([self.refreshControl isRefreshing]){
                    [self.refreshControl endRefreshing];
                }
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                               message:@"Check to make sure that your location services are on and you are connected to a network"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alert addAction:dismissAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
    }];
    [dataTask resume];
}

@end