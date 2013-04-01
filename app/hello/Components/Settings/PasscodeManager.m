//
//  PasscodeManager.m
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import "PasscodeManager.h"
#import "ConfigurationManager.h"
#import "PasscodeView.h"
#import "Workflow.h"

@interface PasscodeManager() 

@end

static UIView* blackScreenInstance = nil;

@implementation PasscodeManager

+ (BOOL)isPasscodeEnabled {
    NSString* passcode = [PasscodeManager retrievePasscode];
    return ![NSString isNullOrEmpty:passcode];
}

+ (NSString *)retrievePasscode {
    return [[NSUserDefaults standardUserDefaults]stringForKey:PASSWORD_KEY];
}

+ (Workflow*)createCheckPasscodeWorkflowCancelable:(BOOL)cancelable {
    return [PasscodeManager createCheckPasscodeWorkflowCancelable:cancelable withTipText:nil animated:YES];
}

+ (Workflow*)createCheckPasscodeWorkflowCancelable:(BOOL)cancelable withTipText:(NSString*)tipText animated:(BOOL)animated {
    Workflow* workflow = [[Workflow alloc]init];

    [workflow setAction:^(id<WorkflowDelegate> delegate) {
        NSMutableDictionary* context = [delegate retrieveContext];
        PasscodeView* passcodeView = (PasscodeView*)[PasscodeView instanceFromNib];
        passcodeView.showCancelButton = cancelable;
        if (tipText != nil) {
            passcodeView.displayText = tipText;
        }
        passcodeView.checkPasscodeHandler = ^(int result) {
            if (result == CheckPasscodeCanceled)
                [context setObject:@"canceled" forKey:@"result"];
            else
                [context setObject:@"succeeded" forKey:@"result"];
            
            [delegate sendMessage:@"end"];
        };
        [[UIViewController topViewController]presentViewController:passcodeView animated:animated completion:nil];
    }
          withMesageMap:[NSDictionary dictionary]
                 forKey:START_STATE_KEY];
    
    return workflow;
}

+ (void)checkPasscode {
    if (![PasscodeManager isPasscodeEnabled])
        return;
    
    static Workflow* workflow = nil;

    if (workflow)
        return;
    
    workflow = [PasscodeManager createCheckPasscodeWorkflowCancelable:NO];
    
    workflow.workflowCompleteHandler = ^(){
        CLEAN_RELEASE(workflow);
        [[UIViewController topViewController]viewWillAppear:NO];
    };
    
    [workflow execute];
}

+ (void)changePasscode {
    if (![PasscodeManager isPasscodeEnabled])
        return;
    
    static Workflow* workflow = nil;
    
    if (workflow)
        return;
    
    workflow = [PasscodeManager createCheckPasscodeWorkflowCancelable:YES withTipText:@"输入当前密码" animated:YES];
    
    workflow.workflowCompleteHandler = ^(){
        NSDictionary* context = [workflow retrieveContext];
        CLEAN_RELEASE(workflow);
        if ([[context objectForKey:@"result"]isEqualToString:@"succeeded"]){
            workflow = [PasscodeManager createSetPasscodeWorkflow];
            workflow.workflowCompleteHandler = ^(){
                CLEAN_RELEASE(workflow);
                [[UIViewController topViewController]viewWillAppear:NO];
            };
            [workflow execute];
        }
        else
            [[UIViewController topViewController]viewWillAppear:NO];
    };
    
    [workflow execute];
}

+ (Workflow*)createSetPasscodeWorkflow {
    Workflow* workflow = [[Workflow alloc]init];
    
    [workflow setAction:^(id<WorkflowDelegate> delegate) {
        NSMutableDictionary* context = [delegate retrieveContext];
        PasscodeView* view = (PasscodeView*)[PasscodeView instanceFromNib];
        view.showCancelButton = YES;
        view.isInputMode = YES;
        view.displayText = @"请输入新密码";
        if ([[context objectForKey:@"retry"]boolValue]) {
            view.displayText = @"密码不匹配，请重新输入";
            view.showErrorScene = YES;
        }
        view.checkPasscodeHandler = ^(int result) {
            if (result == CheckPasscodeFilled) {
                [context setObject:view.userInputText forKey:@"password1"];
                [delegate sendMessage:@"getinput"];
            }
            else {
                [delegate sendMessage:@"end"];
            }
        };
        [[UIViewController topViewController]presentViewController:view animated:YES completion:nil];
    }
          withMesageMap:[NSDictionary dictionaryWithObjectsAndKeys:@"confirmation", @"getinput", nil] forKey:@"start"];
    
    [workflow setAction:^(id<WorkflowDelegate> delegate){
        PasscodeView* view = (PasscodeView*)[PasscodeView instanceFromNib];
        view.displayText = @"请再次输入密码";
        view.isInputMode = YES;
        view.showCancelButton = YES;
        view.checkPasscodeHandler = ^(int result) {
            if (result == CheckPasscodeFilled) {
                NSMutableDictionary* context = [delegate retrieveContext];
                if ([view.userInputText isEqual:[context objectForKey:@"password1"]]) {
                    [PasscodeManager installPasscode:view.userInputText];
                    [delegate sendMessage:@"end"];
                }
                else {
                    [context setObject:[NSNumber numberWithBool:YES] forKey:@"retry"];
                    [delegate sendMessage:@"inconsistent"];
                }
            }
            else {
                [delegate sendMessage:@"end"];
            }
        };
        [[UIViewController topViewController]presentViewController:view animated:YES completion:nil];
    }
          withMesageMap:[NSDictionary dictionaryWithObjectsAndKeys:@"start", @"inconsistent", nil] forKey:@"confirmation"];

    return workflow;
}

+ (void)turnOnPasscode {
    if ([PasscodeManager isPasscodeEnabled])
        return;
    
    static Workflow* workflow = nil;
    
    if (workflow)
        return;
    
    workflow = [PasscodeManager createSetPasscodeWorkflow];
    
    workflow.workflowCompleteHandler = ^() {
        CLEAN_RELEASE(workflow);
        [[UIViewController topViewController]viewWillAppear:NO];
    };
    
    [workflow execute];
}

+ (void)installPasscode:(NSString*)passcode {
    if (!passcode || passcode.length != 4)
        return;
    
    [[NSUserDefaults standardUserDefaults]setObject:passcode forKey:PASSWORD_KEY];
}

+ (void)clearPassword {
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:PASSWORD_KEY];
}

+ (void)turnOffPasscode {
    if (![PasscodeManager isPasscodeEnabled])
        return;
    
    static Workflow* workflow = nil;
    
    if (workflow)
        return;
    
    workflow = [[Workflow alloc]init];
    
    [workflow setAction:^(id<WorkflowDelegate> delegate){
        PasscodeView* passcodeView = (PasscodeView*)[PasscodeView instanceFromNib];
        passcodeView.showCancelButton = YES;
        passcodeView.checkPasscodeHandler = ^(int result){
            if (result == CheckPasscodeSucceeded)
                [PasscodeManager clearPassword];

            [delegate sendMessage:@"end"];
        };
        
        [[UIViewController topViewController]presentViewController:passcodeView animated:YES completion:nil];
    } withMesageMap:[NSDictionary dictionary] forKey:START_STATE_KEY];
    
    workflow.workflowCompleteHandler = ^(){
        CLEAN_RELEASE(workflow);
        [[UIViewController topViewController]viewWillAppear:NO];
    };
    
    [workflow execute];
}

+ (void)presentBlackScreen {
    if (blackScreenInstance)
        return;
    
    UIView* blackView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.opaque = NO;
    UIViewController* topView = [UIViewController topViewController];
    [topView.view addSubview:blackView];
    [topView.view bringSubviewToFront:blackView];
    blackScreenInstance = blackView;
}

+ (void)dismissBlackScreen {
    if (!blackScreenInstance)
        return;
    
    [UIView animateWithDuration:0.2
                     animations:^(){
                         blackScreenInstance.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [blackScreenInstance removeFromSuperview];
                             CLEAN_RELEASE(blackScreenInstance);
                         }
    }];
}

@end
