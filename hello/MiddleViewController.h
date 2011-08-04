//
//  MiddleViewController.h
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"
#import "ExpenseManager.h"

enum KeyTag {
    key1 = 1,
    key2 = 2,
    key3 = 3,
    key4 = 4,
    key5 = 5,
    key6 = 6,
    key7 = 7,
    key8 = 8,
    key9 = 9,
    key0 = 10,
    keyPlus = -1,
    keyMinus = -2,
    keyMultiply = -3,
    keyDivide = -4,
    keyDot = -5,
    keyDelete = -6
};

typedef enum _Operator {
    opNone = 0,
    opPlus = keyPlus,
    opMinus = keyMinus,
    opMultiply = keyMultiply,
    opDivide = keyDivide
}Operator;

#define TOL 0.0000001;
#define fuzzyEqual(a, b) ({ABS(a - b) < TOL})

@interface MiddleViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    double prevNumber;
    double curNumber;
    Operator activeOp;
    BOOL isCurNumberDirty;
    UIView* activeFloatingView;
    Expense* editingExpense_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil editItem:(Expense*)expense;

- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onNumPadKey:(id)sender;
- (IBAction)onSelectCategory:(id)sender;
- (IBAction)onPickDate:(id)sender;
- (IBAction)onDateChanged:(id)sender;
- (IBAction)onPickPhoto:(id)sender;
- (IBAction)onShowKeyboard:(id)sender;
- (IBAction)onShowCategory:(id)sender;

@property(nonatomic, retain) IBOutlet UITextView* uiNotes;
@property(nonatomic, retain) IBOutlet UILabel* uiNumber;
@property(nonatomic, retain) IBOutlet UIButton* uiDate;
@property(nonatomic, retain) IBOutlet CategoryViewController* catViewController;
@property(nonatomic, retain) IBOutlet UIView* inputPlaceHolder;
@property(nonatomic, retain) IBOutlet UIButton* categoryButton;
@property(nonatomic, retain) IBOutlet UIView* numPadView;
@property(nonatomic, retain) IBOutlet UIView* datePickerView;
@property(nonatomic, retain) IBOutlet UIButton* imageButton;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UIImageView* frameView;

@property(nonatomic, retain) NSString* inputText;
@property(nonatomic, retain) NSDate* currentDate;
@property(nonatomic, retain) UIImage* imageUnknown;

- (void)syncUi;
- (void)pushOp:(Operator)op;

@end
