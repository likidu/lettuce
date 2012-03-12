//
//  PasscodeView.h
//  woojuu
//
//  Created by Lee Rome on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasscodeView : UIViewController <UITextFieldDelegate>

+ (void)checkPasscode;
+ (void)setPasscode;

- (IBAction)textFieldTextChanged:(id)sender;

@property(nonatomic,retain) IBOutlet UILabel* defaultLabel;
@property(nonatomic,retain) IBOutlet UILabel* errorLabel;

@property(nonatomic,retain) IBOutlet UIImageView* defaultImage;
@property(nonatomic,retain) IBOutlet UIImageView* errorImage;

@property(nonatomic,retain) IBOutlet UITextField* textField;

@property(nonatomic,retain) NSString* userInputText;

@end
