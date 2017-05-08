//
//  PWSearchTextFieldView.m
//  PWConvienceStoreTracker
//
//  Created by Patrick Wiseman on 5/18/16.
//  Copyright © 2016 Patrick Wiseman. All rights reserved.
//

#import "PWSearchTextFieldView.h"
#import "UIColor+Colors.h"

@implementation PWSearchTextFieldView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        //setup background UIView container
        int containerViewX = 8;
        int containerViewY = 6;
        int containerViewWidth = frame.size.width - (containerViewX*2);
        int containerViewHeight = frame.size.height - (containerViewY*2);
        CGRect containerViewFrame = CGRectMake(containerViewX,
                                           containerViewY,
                                           containerViewWidth,
                                           containerViewHeight);
        UIView *containerView = [[UIView alloc] initWithFrame:containerViewFrame];
        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = containerViewHeight/4;
        [self addSubview:containerView];
        //setup text field
        int textFieldX = 6;
        int textFieldY = 0;
        int textFieldWidth = containerViewWidth - (textFieldX*2);
        int textFieldHeight = containerViewHeight;
        CGRect textFieldFrame = CGRectMake(textFieldX,
                                           textFieldY,
                                           textFieldWidth,
                                           textFieldHeight);
        self.textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        self.textField.returnKeyType = UIReturnKeySearch;
        [containerView addSubview:self.textField];
        self.textField.clearButtonMode = UITextFieldViewModeAlways;
        self.textField.backgroundColor = [UIColor whiteColor];
        //setup view
        self.backgroundColor = [UIColor primaryColor];
    }
    
    return self;
}

-(void)setStandardPlaceholderWithText:(NSString *)placeholderText
{
    if(self.locationMode == YES){
        self.textField.placeholder = @"";
        self.textField.text = @"Current Location";
        self.textField.textColor = [UIColor peterRiverColor];
        self.textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Current_Location_Indicator"]];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    } else {
        self.textField.placeholder = placeholderText;
        self.textField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search_Image"]];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

-(void)hideStandardPlaceholder
{
    if(self.locationMode == YES){
        self.textField.text = @"";
        self.textField.textColor = [UIColor blackColor];
        self.textField.leftView = nil;
    } else {
        self.textField.placeholder = @"";
        self.textField.leftView = nil;
    }
}

@end
