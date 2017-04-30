//
//  PWNetworkManager.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWNetworkManager.h"
#import "VenueObject.h"

@implementation PWNetworkManager

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";
//Api URL String Formats
static NSString * const currentLocationVenueSearchApiUrl =
@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%f,%f&query=%@";
static NSString * const nonCurrentLocationVenueSearchApiUrl =
@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&near=%@&query=%@";

+(void)getNearbyFoodWithLocationString:(NSString *)locationString
                          searchString:(NSString *)searchString
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude
                            urlSession:(NSURLSession *)session
{
    NSString *text;
    if(searchString.length == 0){
        text = @"burgers";
    } else {
        text = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *fourSquareDataUrlString;
    if([locationString isEqualToString:@"Current Location"]){
        fourSquareDataUrlString = [NSString stringWithFormat:currentLocationVenueSearchApiUrl,
                                   clientId,
                                   clientSecret,
                                   latitude,
                                   longitude,
                                   text];
    } else {
        fourSquareDataUrlString = [NSString stringWithFormat:nonCurrentLocationVenueSearchApiUrl,
                                   clientId,
                                   clientSecret,
                                   locationString,
                                   text];
    }
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithURL:[NSURL URLWithString:fourSquareDataUrlString]
           completionHandler:^(NSData * _Nullable data,
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
                    NSArray *venuesArray = responseDictionary[@"venues"];
                    NSArray *results = [self parseVenueInformationWithVenues:venuesArray
                                                              searchLatitude:latitude
                                                             searchLongitude:longitude];
//                    for(NSDictionary *dictionary in venuesArray){
//                        //Lat and Lon
//                        NSString *tempLat = [dictionary valueForKeyPath:@"location.lat"];
//                        NSString *tempLon = [dictionary valueForKeyPath:@"location.lng"];
//                        float lat = (CGFloat)[tempLat floatValue];
//                        float lon = (CGFloat)[tempLon floatValue];
//                        //Address
//                        NSArray *addressArray = [dictionary valueForKeyPath:@"location.formattedAddress"];
//                        NSString *addressString;
//                        if([addressArray count] == 2){
//                            addressString = [NSString stringWithFormat:@"%@, %@", addressArray[0], addressArray[1]];
//                        } else {
//                            addressString = [NSString stringWithFormat:@"%@, %@, %@", addressArray[0], addressArray[1], addressArray[2]];
//                        }
//                        CLLocation *currentLocation =
//                        [[CLLocation alloc] initWithLatitude:latitude
//                                                   longitude:longitude];
//                        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
//                        CLLocationDistance distance = [venueLocation distanceFromLocation:currentLocation];
//                        NSString *distanceString = [NSString stringWithFormat:@"%.02f", distance/1609.34];
//                        VenueObject *venueObject =
//                        [[VenueObject alloc] initWithLatitude:lat
//                                                    longitude:lon
//                                                         name:dictionary[@"name"]
//                                                      address:addressString
//                                                     distance:distanceString
//                                            simplifiedAddress:addressArray[0]
//                                                      venueId:dictionary[@"id"]
//                                                  phoneNumber:[dictionary valueForKeyPath:@"contact.formattedPhone"]
//                                                      website:dictionary[@"url"]];
//                        [returnedResults addObject:venueObject];
//                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"venuSearchComplete"
                                                                        object:nil
                                                                      userInfo:@{@"results":results,
                                                                                 @"status":@1}];
//                    self.venueList = returnedResults;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                        if([self.refreshControl isRefreshing]){
//                            [self.refreshControl endRefreshing];
//                        }
//                        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//                        [self.tableView reloadData];
//                    });
                }
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"venuSearchComplete"
                                                                    object:nil
                                                                  userInfo:@{@"error":@"200 status not returned.",
                                                                             @"status":@0}];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                    if([self.refreshControl isRefreshing]){
//                        [self.refreshControl endRefreshing];
//                    }
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
//                                                                                   message:@"Check to make sure that your location services are on and you are connected to a network"
//                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    }];
//                    [alert addAction:dismissAction];
//                    [self presentViewController:alert animated:YES completion:nil];
//                });
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"venuSearchComplete"
                                                                object:nil
                                                              userInfo:@{@"error":error,
                                                                         @"status":@0}];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//                if([self.refreshControl isRefreshing]){
//                    [self.refreshControl endRefreshing];
//                }
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
//                                                                               message:@"Check to make sure that your location services are on and you are connected to a network"
//                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }];
//                [alert addAction:dismissAction];
//                [self presentViewController:alert animated:YES completion:nil];
//            });
        }
    }];
    [dataTask resume];
}

+(NSArray *)parseVenueInformationWithVenues:(NSArray *)venues
                             searchLatitude:(CGFloat)latitude
                            searchLongitude:(CGFloat)longitude {
    NSMutableArray *returnedResults = [[NSMutableArray alloc] init];
    for(NSDictionary *dictionary in venues){
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
        [[CLLocation alloc] initWithLatitude:latitude
                                   longitude:longitude];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        CLLocationDistance distance = [venueLocation distanceFromLocation:currentLocation];
        NSString *distanceString = [NSString stringWithFormat:@"%.02f", distance/1609.34];
        //Venue Object
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
    return [NSArray arrayWithArray:returnedResults];
}

@end
