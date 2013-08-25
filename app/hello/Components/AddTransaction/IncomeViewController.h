//
//  IncomeViewController.h
//  woojuu
//
//  Created by syrett on 13-8-25.
//  Copyright (c) 2013年 JingXi Mill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "UIImageNoteViewController.h"
#import "MiddleViewController.h"

#define TOL 0.0000001;
#define fuzzyEqual(a, b) ({ABS(a - b) < TOL})
typedef void(^IncomeViewControllerDismissedHandler)();

@interface IncomeViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageNoteViewContollerDelegate,UITextViewDelegate,CategoryViewControllerDelegate>

- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onPickdate:(id)sender;
- (IBAction)switchToexpense:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *uiNumber;

@property(nonatomic, retain) NSString* inputText;
@property(nonatomic, retain) NSDate* currentDate;
@property(nonatomic, retain) UIImage* imageUnknown;
//@property(nonatomic, retain) Expense* editingItem;
@property(nonatomic, retain) UIImageNoteViewController* imageNoteViewController;

@property(nonatomic, copy)  IncomeViewControllerDismissedHandler dismissedHandler;

@end
