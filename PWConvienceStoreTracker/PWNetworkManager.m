//
//  PWNetworkManager.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 4/30/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWNetworkManager.h"
#import "VenueObject.h"
#import "PWVenuePhotoObject.h"

@implementation PWNetworkManager

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";
//Api URL String Formats
static NSString * const currentLocationVenueSearchApiUrl =
@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&ll=%f,%f&query=%@";
static NSString * const nonCurrentLocationVenueSearchApiUrl =
@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20130815&near=%@&query=%@";
static NSString *const imageSearchApiUrl =
@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=20160406&group=venue&limit=1";

//Venue
+(void)getNearbyFoodWithLocationString:(NSString *)locationString
                          searchString:(NSString *)searchString
                              latitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude
                            urlSession:(NSURLSession *)session
                       completionBlock:(void (^)(NSArray *results))processVenues
                       failureBlock:(void (^)(NSError *error))processError
{
    NSString *text = [self formatSearchForUrlWithText:searchString];
    NSString *fourSquareDataUrlString;
    if([locationString isEqualToString:@"Current Location"]){
        fourSquareDataUrlString = [NSString stringWithFormat:currentLocationVenueSearchApiUrl,
                                   clientId,
                                   clientSecret,
                                   latitude,
                                   longitude,
                                   text];
    } else {
        locationString = [self formatLocationForUrlWithText:locationString];
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
                    processVenues(results);
                }
            } else {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                     code:400
                                                 userInfo:nil];
                processError(error);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                                 code:400
                                             userInfo:nil];
            processError(error);
        }
    }];
    [dataTask resume];
}

+(NSString *)formatSearchForUrlWithText:(NSString *)searchText {
    NSString *newSearchText = @"burgers";
    if(searchText.length > 0){
        newSearchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }
    return newSearchText;
}

+(NSString *)formatLocationForUrlWithText:(NSString *)locationText {
    NSString *newLocationText = [locationText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return newLocationText;
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
                                      website:dictionary[@"url"]
                                    urlString:@"none"];
        [returnedResults addObject:venueObject];
    }
    return [NSArray arrayWithArray:returnedResults];
}

//Photos
+(void)getVenueImageWithVenue:(VenueObject *)venue
                       session:(NSURLSession *)session
               completionBlock:(void (^)(NSString *imageUrlString))processUrl
{
    NSString *fourSquareDataUrlString = [NSString stringWithFormat:imageSearchApiUrl,
                                         venue.venueId,
                                         clientId,
                                         clientSecret];
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
                           NSString *imageUrlString = @"default";
                           NSArray *photoArray = [responseDictionary valueForKeyPath:@"photos.items"];
                           if([photoArray count] > 0){
                               NSDictionary *photo = [photoArray objectAtIndex:0];
                               NSString *prefixString = photo[@"prefix"];
                               NSString *suffixString = photo[@"suffix"];
                               NSNumber *width = photo[@"width"];
                               NSNumber *height = photo[@"height"];
                               NSString  *widthString = [NSString stringWithFormat:@"%@", width];
                               NSString  *heightString = [NSString stringWithFormat:@"%@", height];
                               imageUrlString = [NSString stringWithFormat:@"%@%@x%@%@", prefixString, widthString, heightString, suffixString];
                               venue.defaultImageUrlString = imageUrlString;
                           } else {
                               venue.defaultImageUrlString = imageUrlString;
                           }
                           processUrl(venue.defaultImageUrlString);
                       }
                   } else {
                       //ERROR
                   }
               } else {
                   //ERROR
               }
           }];
    [dataTask resume];
}

+(void)loadImageWithUrlString:(NSString *)urlString
              completionBlock:(void (^)(UIImage *image))processImage {
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_queue_t downloadQueue = dispatch_queue_create("com.burgby.processimagequeue", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        processImage(image);
    });
}

+(void)getVenueImagesWithVenue:(VenueObject *)venue
                       session:(NSURLSession *)session
               completionBlock:(void (^)(NSArray *photoUrlStringArray))processImages
{
    NSString *fourSquareDataUrlString =
    [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=20160406",
     venue.venueId,
     clientId,
     clientSecret];
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
                    NSMutableArray *tempPhotoUrlStringArray = [[NSMutableArray alloc] init];
                    NSDictionary *responseDictionary = responseObject[@"response"];
                    NSArray *photoArray = [responseDictionary valueForKeyPath:@"photos.items"];
                    NSLog(@"Photo Array: %lu", (unsigned long)[photoArray count]);
                    for(NSDictionary *dictionary in photoArray){
                        NSString *prefixString = dictionary[@"prefix"];
                        NSString *suffixString = dictionary[@"suffix"];
                        NSNumber *width = dictionary[@"width"];
                        NSNumber *height = dictionary[@"height"];
                        NSString  *widthString = [NSString stringWithFormat:@"%@", width];
                        NSString  *heightString = [NSString stringWithFormat:@"%@", height];
                        NSString *imageUrlString = [NSString stringWithFormat:@"%@%@x%@%@",
                                                    prefixString, widthString, heightString, suffixString];
                        PWVenuePhotoObject *object = [[PWVenuePhotoObject alloc]
                                                      initWithPhotoUrlString:imageUrlString];
                        [tempPhotoUrlStringArray addObject:object];
                    }
                    NSArray *photoUrlStringArray = [NSArray arrayWithArray:tempPhotoUrlStringArray];
                    processImages(photoUrlStringArray);
                }
            }
        } else {
            NSLog(@"ERROR: %@", error);
        }
    }];
    [dataTask resume];
}

+(void)getTrendingVenues {
    
}

@end
