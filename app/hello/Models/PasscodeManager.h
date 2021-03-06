//
//  PasscodeManager.h
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import <Foundation/Foundation.h>
#import "Workflow.h"

@interface PasscodeManager : NSObject<UIViewControllerDelegate>

+ (void)checkPasscode;
+ (void)changePasscode;
+ (void)turnOffPasscode;
+ (void)turnOnPasscode;

+ (BOOL)isPasscodeEnabled;

+ (Workflow*)createCheckPasscodeWorkflowCancelable:(BOOL)cancelable;
+ (Workflow*)createCheckPasscodeWorkflowCancelable:(BOOL)cancelable withTipText:(NSString*)tipText animated:(BOOL)animated;

+ (void)presentBlackScreen;
+ (void)dismissBlackScreen;

@end
