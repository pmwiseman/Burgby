//
//  PWSearchTextFieldView.h
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/18/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWSearchTextFieldView : UIView

//Properties
@property (strong, nonatomic) UITextField *textField;
@property (assign) BOOL locationMode;
//Methods
-(void)setStandardPlaceholderWithText:(NSString *)placeholderText;
-(void)hideStandardPlaceholder;

@end
