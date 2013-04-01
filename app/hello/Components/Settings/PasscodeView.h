//
//  PasscodeView.h
//  woojuu
//
//  Created by Lee Rome on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CheckPasscodeResult {
    CheckPasscodeSucceeded = 0,
    CheckPasscodeCanceled = 1,
    CheckPasscodeFilled = 2
};

typedef void(^DidCheckPasscode)(int result);

@interface PasscodeView : UIViewController <UITextFieldDelegate>

- (IBAction)textFieldTextChanged:(id)sender;
- (IBAction)onCancel;

@property(nonatomic,retain) IBOutlet UILabel* defaultLabel;
@property(nonatomic,retain) IBOutlet UILabel* errorLabel;

@property(nonatomic,retain) IBOutlet UIImageView* defaultImage;
@property(nonatomic,retain) IBOutlet UIImageView* errorImage;

@property(nonatomic,retain) IBOutlet UIImageView* defaultHeader;
@property(nonatomic,retain) IBOutlet UIImageView* errorHeader;

@property(nonatomic,retain) IBOutlet UILabel* defaultTitle;
@property(nonatomic,retain) IBOutlet UILabel* errorTitle;

@property(nonatomic,retain) IBOutlet UIButton* defaultCancelButton;
@property(nonatomic,retain) IBOutlet UIButton* errorCancelButton;

@property(nonatomic,retain) IBOutlet UITextField* textField;

@property(nonatomic,retain) NSString* userInputText;

@property(nonatomic,assign) BOOL showCancelButton;
@property(nonatomic,assign) BOOL showErrorScene;
@property(nonatomic,retain) NSString* displayText;
@property(nonatomic,retain) NSString* displayTitle;

@property(nonatomic,assign) BOOL isInputMode;

@property(nonatomic,copy) DidCheckPasscode checkPasscodeHandler;

@end
