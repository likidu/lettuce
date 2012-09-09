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
@synthesize textField;

+ (void)checkPasscode {
    NSString* passcode = [[NSUserDefaults standardUserDefaults]stringForKey:PASSWORD_KEY];
    if (!passcode || passcode.length != 4)
        return;
    
    PasscodeView* view = [[PasscodeView alloc]initWithNibName:@"PasscodeView" bundle:[NSBundle mainBundle]];
    UIApplication* app = [UIApplication sharedApplication];
    [app.keyWindow.rootViewController presentModalViewController:view animated:NO];
}

+ (void)setPasscode {
    [[NSUserDefaults standardUserDefaults]setValue:@"8223" forKey:PASSWORD_KEY];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.defaultImage = nil;
    self.defaultLabel = nil;
    self.errorImage = nil;
    self.errorLabel = nil;
    self.userInputText = nil;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.defaultImage = nil;
    self.defaultLabel = nil;
    self.errorImage = nil;
    self.errorLabel = nil;
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

- (void)viewWillAppear:(BOOL)animated {
    self.userInputText = @"";
    [self setTextFieldText:userInputText];
    defaultImage.hidden = NO;
    defaultLabel.hidden = NO;
    errorImage.hidden = YES;
    errorLabel.hidden = YES;
    self.textField.text = @"";
    
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
        [self dismissModalViewControllerAnimated:YES];
    else {
        self.userInputText = @"";
        defaultLabel.hidden = YES;
        defaultImage.hidden = YES;
        errorLabel.hidden = NO;
        errorImage.hidden = NO;
        self.textField.text = @"";
    }
    [self setTextFieldText:userInputText];
}

- (void)textFieldTextChanged:(id)sender {
    if (isInternalSetText)
        return;
    
    self.userInputText = self.textField.text;
    
    [self setTextFieldText:userInputText];

    if (userInputText.length == 4)
        [self performSelector:@selector(verifyPasscode) withObject:nil afterDelay: 0.15];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""] && userInputText.length > 0) {
        NSRange range = {0, userInputText.length - 1};
        self.userInputText = [userInputText substringWithRange:range];
        [self setUserInputText:userInputText];
    }
    return YES;
}

@end
