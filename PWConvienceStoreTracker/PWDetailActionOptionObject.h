//
//  PWDetailActionOptionObject.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/7/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PWDetailActionOptionObject : NSObject

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) int tag;
@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *associatedString;

-(id)initWithTitle:(NSString *)theTitle
       imageString:(NSString *)theImageString
               tag:(int)theTag
  associatedString:(NSString *)theAssociatedString;

@end
