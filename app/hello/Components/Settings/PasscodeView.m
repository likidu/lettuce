//
//  PasscodeView.m
//  woojuu
//
//  Created by Lee Rome on 11-11-15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PasscodeView.h"
#import "ConfigurationManager.h"

@implementation PasscodeView

@synthesize userInputText;
@synthesize defaultImage;
@synthesize defaultLabel;
@synthesize errorImage;
@synthesize errorLabel;
@synthesize defaultHeader;
@synthesize errorHeader;
@synthesize defaultTitle;
@synthesize errorTitle;
@synthesize textField;
@synthesize showCancelButton;
@synthesize showErrorScene;
@synthesize checkPasscodeHandler;
@synthesize isInputMode;
@synthesize displayText;
@synthesize displayTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showErrorScene = NO;
        self.showCancelButton = YES;
        self.isInputMode = NO;
        self.displayText = nil;
        self.displayTitle = nil;
    }
    return self;
}

- (void)dealloc {
    self.defaultImage = nil;
    self.defaultLabel = nil;
    self.errorImage = nil;
    self.errorLabel = nil;
    self.defaultCancelButton = nil;
    self.errorCancelButton = nil;
    self.defaultHeader = nil;
    self.errorHeader = nil;
    self.defaultTitle = nil;
    self.errorTitle = nil;
    self.userInputText = nil;
    self.displayTitle = nil;
    self.displayText = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserver:self forKeyPath:@"showCancelButton" options:0 context:nil];
    [self addObserver:self forKeyPath:@"showErrorScene" options:0 context:nil];
    [self addObserver:self forKeyPath:@"displayText" options:0 context:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.defaultImage = nil;
    self.defaultLabel = nil;
    self.errorImage = nil;
    self.errorLabel = nil;
    self.defaultCancelButton = nil;
    self.errorCancelButton = nil;
    self.defaultHeader = nil;
    self.errorHeader = nil;
    self.defaultTitle = nil;
    self.errorTitle = nil;
    [self removeObserver:self forKeyPath:@"showCancelButton"];
    [self removeObserver:self forKeyPath:@"showErrorScene"];
    [self removeObserver:self forKeyPath:@"displayText"];
}

bool isInternalSetText = false;

- (void)setTextFieldText:(NSString*)text {
    UITextField* controls[4] = {
        (UITextField*)[self.view viewWithTag:1],
        (UITextField*)[self.view viewWithTag:2],
        (UITextField*)[self.view viewWithTag:3],
        (UITextField*)[self.view viewWithTag:4]
    };
    
    isInternalSetText = true;
    for (int i = 0; i < 4; i++) {
        if (i < text.length)
            controls[i].text = @"*";
        else
            controls[i].text = @"";
    }
    isInternalSetText = false;
}

- (void)updateScene {
    self.defaultTitle.hidden = self.showErrorScene;
    self.defaultHeader.hidden = self.showErrorScene;
    self.defaultImage.hidden = self.showErrorScene;
    self.defaultLabel.hidden = self.showErrorScene;
    self.errorHeader.hidden = !self.showErrorScene;
    self.errorImage.hidden = !self.showErrorScene;
    self.errorLabel.hidden = !self.showErrorScene;
    self.errorTitle.hidden = !self.showErrorScene;
    
    self.defaultCancelButton.hidden = !(self.showCancelButton && !self.showErrorScene);
    self.errorCancelButton.hidden = !(self.showCancelButton && self.showErrorScene);
    
    if (self.displayText) {
        self.defaultLabel.text = self.displayText;
        self.errorLabel.text = self.displayText;
    }
    
    if (self.displayTitle) {
        self.defaultTitle.text = self.displayTitle;
        self.errorTitle.text = self.displayTitle;
    }
        
}

- (void)didChangeValueForKey:(NSString *)key {
    if ([key isEqualToString:@"showCancelButton"] || [key isEqualToString:@"showErrorScene"]
        || [key isEqualToString:@"displayText"]) {
        [self updateScene];
    }
    else
        [super didChangeValueForKey:key];
}


- (void)viewWillAppear:(BOOL)animated {
    self.userInputText = @"";
    [self setTextFieldText:userInputText];
    self.textField.text = @"";
    [self updateScene];
    
    [self.textField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)verifyPasscode {
    NSString* code = [[NSUserDefaults standardUserDefaults]stringForKey:PASSWORD_KEY];
    if ([userInputText compare: code] == NSOrderedSame)
    {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
            if (self.checkPasscodeHandler)
                self.checkPasscodeHandler(CheckPasscodeSucceeded);
        }];
    }
    else {
        self.userInputText = @"";
        self.showErrorScene = YES;
        self.textField.text = @"";
    }
    [self setTextFieldText:userInputText];
}

- (void)sendPasscode {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
        if (self.checkPasscodeHandler)
            self.checkPasscodeHandler(CheckPasscodeFilled);
    }];
}

- (void)textFieldTextChanged:(id)sender {
    if (isInternalSetText)
        return;
    
    self.userInputText = self.textField.text;
    
    [self setTextFieldText:userInputText];

    if (userInputText.length == 4) {
        if (self.isInputMode)
            [self performSelector:@selector(sendPasscode) withObject:nil afterDelay: 0.15];
        else
            [self performSelector:@selector(verifyPasscode) withObject:nil afterDelay: 0.15];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && userInputText.length > 0) {
        NSRange range = {0, userInputText.length - 1};
        self.userInputText = [userInputText substringWithRange:range];
        [self setUserInputText:userInputText];
    }
    return YES;
}

- (void)performCancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^(){
        if (self.checkPasscodeHandler)
            self.checkPasscodeHandler(CheckPasscodeCanceled);
    }];
}

- (void)onCancel {
    [self performSelector:@selector(performCancel) withObject:nil afterDelay:0.15];
}

@end
