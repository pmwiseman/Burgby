//
//  PWImageView.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/6/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import "PWImageView.h"

@implementation PWImageView

//Four Square Creds
static NSString * const clientId = @"3ZG0AS0KRCAX1VINA0LWRFGCT00YYCPJ1CDYTLSUGXW4LFSH";
static NSString * const clientSecret = @"QLITWC3K5U3PASW0BRGR5IQMZJE04NYSC5HQDH3MOYOTJCOJ";
//Api URL String Formats
static NSString *const imageSearchApiUrl =
@"https://api.foursquare.com/v2/venues/%@/photos?client_id=%@&client_secret=%@&v=20160406&group=venue&limit=1";

-(void)getImageWithUrlString:(NSString *)urlString {
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
//    self.cachedImage = image;
//    NSLog(@"Cached: %f", self.cachedImage.size.width);
//    self.image = image;
}

//Photos
-(void)getVenueImagesWithVenueId:(NSString *)venueId
                         session:(NSURLSession *)session
{
    if(!self.cachedImage){
        //    self.sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *fourSquareDataUrlString = [NSString stringWithFormat:imageSearchApiUrl,
                                             venueId,
                                             clientId,
                                             clientSecret];
        //    if(!self.session){
        //        self.session = [NSURLSession sessionWithConfiguration:self.sessionConfiguration
        //                                                     delegate:self
        //                                                delegateQueue:nil];
        //    }
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
                               NSLog(@"RESPONSE: %@", responseObject);
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
                                   [self getImageWithUrlString:imageUrlString];
                               } else {
                                   self.image = [UIImage new];
                               }
                               //                    NSDictionary *responseDictionary = responseObject[@"response"];
                               //                    NSArray *photoArray = [responseDictionary valueForKeyPath:@"photos.items"];
                               //                    if([photoArray count] > 0){
                               //                        NSDictionary *dictionary = [photoArray objectAtIndex:0];
                               //                        NSString *prefixString = dictionary[@"prefix"];
                               //                        NSString *suffixString = dictionary[@"suffix"];
                               //                        NSNumber *width = dictionary[@"width"];
                               //                        NSNumber *height = dictionary[@"height"];
                               //                        NSString  *widthString = [NSString stringWithFormat:@"%@", width];
                               //                        NSString  *heightString = [NSString stringWithFormat:@"%@", height];
                               //                        self.imageUrlString = [NSString stringWithFormat:@"%@%@x%@%@", prefixString, widthString, heightString, suffixString];
                               //                    } else {
                               //                        self.imageUrlString = @"no image";
                               //                    }
                           }
                           //                dispatch_async(dispatch_get_main_queue(), ^{
                           //                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           //                    if(![self.imageUrlString isEqualToString:@"no image"]){
                           //                        self.imageView.image =
                           //                        [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]]];
                           //                    } else {
                           //                        self.imageView.image = [UIImage imageNamed:@"Burgers_Nearby_No_Image_Available"];
                           //                    }
                           //                });
                       }
                   } else {
                       //            NSLog(@"ERROR: %@", error);
                   }
               }];
        [dataTask resume];
    } else {
        self.image = self.cachedImage;
    }
}

//-(void)setCachedUIImage:(UIImage *)cachedUIImage {
//    objc_setAssociatedObject(self, @selector(cachedUIImage), cachedUIImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(UIImage *)cachedUIImage {
//    return objc_getAssociatedObject(self, @selector(cachedUIImage));
//}

@end
