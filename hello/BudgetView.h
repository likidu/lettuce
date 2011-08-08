//
//  BuddgetView.h
//  hello
//
//  Created by Rome Lee on 11-3-18.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuddgetView : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UITextField* uiBudgetEditBox;
@property (nonatomic, retain) IBOutlet UITextField* uiVacationBudgetEditBox;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;

@end
