//
//  MiddleViewController.m
//  hello
//
//  Created by Rome Lee on 11-3-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "MiddleViewController.h"
#import "ExpenseManager.h"
#import "Foundation/NSRange.h"
#import "CategoryManager.h"

@implementation MiddleViewController

@synthesize uiNotes;
@synthesize uiDate;
@synthesize uiNumber;
@synthesize catViewController;
@synthesize inputPlaceHolder;
@synthesize categoryButton;
@synthesize numPadView;
@synthesize datePickerView;
@synthesize imageButton;
@synthesize imageView;
@synthesize frameView;
@synthesize datePicker;
@synthesize editingItem;
@synthesize imageEditButton;
@synthesize formulaLabel;
@synthesize imageNoteViewController;

@synthesize inputText;
@synthesize currentDate;
@synthesize imageUnknown;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentDate = [NSDate date];
        editingExpense_ = nil;
        needReset_ = YES;
        self.imageUnknown = [UIImage imageNamed:@"unknown.png"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil editItem:(Expense *)expense {
    id ret = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    editingExpense_ = [expense retain];
    needReset_ = YES;
    return ret;
}

- (void)setSelectedCategory:(NSNumber*)data {
    if (!data)
        return;
    
    int catId = [data intValue];
    if (catId == -1) {
        setButtonTitleForStates(categoryButton, @"", UIControlStateHighlighted|UIControlStateSelected);
        setButtonImageForStates(categoryButton, imageUnknown, UIControlStateHighlighted|UIControlStateSelected);
        categoryButton.titleEdgeInsets = UIEdgeInsetsZero;
        categoryButton.imageEdgeInsets = UIEdgeInsetsZero;
        return;
    }
    CategoryManager* catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase:NO];
    NSArray* categories = [catMan categoryCollection];
    Category* cat = nil;
    for (Category* tmp in categories) {
        if (tmp.categoryId == catId) {
            cat = tmp;
            break;
        }
    }
    if (cat) {
        UIColor* color = [UIColor darkTextColor];
        setButtonTitleForStates(categoryButton, cat.categoryName, UIControlStateHighlighted|UIControlStateSelected);
        setButtonTitleColorForStates(categoryButton, color, UIControlStateHighlighted|UIControlStateSelected);
        UIImage * image = [catMan iconNamed:cat.iconName];
        setButtonImageForStates(categoryButton, image, UIControlStateHighlighted|UIControlStateSelected);
        categoryButton.tag = catId;
        categoryButton.titleLabel.textAlignment = UITextAlignmentCenter;
        makeToolButton(categoryButton);
    }
    
    [catViewController resetState:catId];
}

- (void)presentView:(UIView*)view {
    [CATransaction begin];
    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    animation.duration = 0.15;
    view.hidden = NO;
    [view.layer addAnimation:animation forKey:@""];
    [CATransaction commit];
}

- (void)dismissInputPad {
    for (UIView* view in self.view.subviews) {
        if (view.isFirstResponder) {
            [view resignFirstResponder];
        }
    }
}

- (void)switchFloatingView:(UIView*)view {
    [self dismissInputPad];
    if (activeFloatingView == view)
        return;
    if (activeFloatingView) {
        [CATransaction begin];
        CATransition* animation = [CATransition animation];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        animation.duration = 0.15;
        [activeFloatingView.layer addAnimation:animation forKey:@""];
        [CATransaction commit];
        activeFloatingView.hidden = YES;
        [self performSelector:@selector(presentView:) withObject:view afterDelay:0.15];
    }
    else
        [self presentView:view];
    
    activeFloatingView = view;
}

- (void)onCancel:(id)sender {
    self.editingItem = nil;
    needReset_ = YES;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onSave:(id)sender {
    Expense* expense = [[[Expense alloc]init]autorelease];
    
    double amount = curNumber;
    if (activeOp != opNone) {
        if (!isCurNumberDirty)
            amount = prevNumber;
        else if (activeOp == opPlus)
            amount = prevNumber + curNumber;
        else if (activeOp == opMinus)
            amount = prevNumber - curNumber;
        else if (activeOp == opMultiply)
            amount = prevNumber * curNumber;
        else if (activeOp == opDivide && !fuzzyEqual(curNumber, 0.0))
            amount = prevNumber / curNumber;
    }
    
    if (amount < 0 || fuzzyEqual(amount, 0.0)) {
        UIAlertView* alertView = [[[UIAlertView alloc]initWithTitle:@"莴苣账本" message:@"支出金额不能为零或负数。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil]autorelease];
        [alertView show];
        return;
    }
    if (categoryButton.tag <= 0) {
        UIAlertView* alertView = [[[UIAlertView alloc]initWithTitle:@"莴苣账本" message:@"请选择一个支出类别。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil]autorelease];
        [alertView show];
        return;
    }
        
    expense.amount = amount;
    expense.notes = uiNotes.text;
    expense.date = self.currentDate;
    expense.categoryId = categoryButton.tag;
    
    ExpenseManager* expMan = [ExpenseManager instance];
    if (imageUpdated_) {
        if (editingItem)
            [expMan deleteImageNote:editingItem.pictureRef];
        expense.pictureRef = [expMan saveImageNote:imageView.image];
    }
    else if (editingItem)
        expense.pictureRef = editingItem.pictureRef;
    
    if (editingItem) {
        expense.expenseId = editingItem.expenseId;
        [expMan updateExpense:expense];
    }
    else
        [expMan addExpense:expense];
    
    self.editingItem = nil;
    needReset_ = YES;

    [self dismissModalViewControllerAnimated:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self switchFloatingView:numPadView];
}

- (void)dealloc
{
    [super dealloc];
    self.currentDate = nil;
    self.imageUnknown = nil;
    [editingExpense_ release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - num pad

- (void)syncUi {
    curNumber = [inputText doubleValue];
    
    double dispNumber = prevNumber;
    if (inputText.length > 0 || isCurNumberDirty)
        dispNumber = curNumber;

    uiNumber.text = [NSString stringWithFormat:@"¥ %.2f", dispNumber];
    if (activeOp != opNone) {
        NSString* opStr = nil;
        if (activeOp == opPlus)
            opStr = @"+";
        else if (activeOp == opMinus)
            opStr = @"-";
        else if (activeOp == opMultiply)
            opStr = @"×";
        else if (activeOp == opDivide)
            opStr = @"÷";
        formulaLabel.text = [NSString stringWithFormat:@"%.2f %@", prevNumber, opStr];
    }
    else
        formulaLabel.text = @"";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"M月d日\nEEEE"];

    [uiDate setTitle:[formatter stringFromDate:self.currentDate] forState:UIControlStateNormal];
}

- (void)pushOp:(Operator)op { 
    // just change the operator
    if (inputText.length == 0) {
        activeOp = op;
        return;
    }
        
    // avoid divide by zero fault
    if (activeOp == opDivide && fuzzyEqual(curNumber, 0.0))
        return;
    
    if (activeOp == opNone)
        prevNumber = curNumber;
    else if (activeOp == opPlus)
        prevNumber += curNumber;
    else if (activeOp == opMinus)
        prevNumber -= curNumber;
    else if (activeOp == opMultiply)
        prevNumber *= curNumber;
    else if (activeOp == opDivide)
        prevNumber /= curNumber;
    else
        return; // error case
    
    curNumber = 0.0;
    inputText = @"";
    isCurNumberDirty = NO;
    activeOp = op;
}

- (void)onNumPadKey:(id)sender {
    UIButton* button = (UIButton*)sender;
    if (button == nil)
        return;
    char cstr[2] = {0,0};
    int posDot = [inputText rangeOfString:@"."].location; 
    switch (button.tag) {
        case key1:
        case key2:
        case key3:
        case key4:
        case key5:
        case key6:
        case key7:
        case key8:
        case key9:
        case key0:
            cstr[0] = '0' + button.tag;
            if (button.tag == key0)
                cstr[0] = '0';
            NSString* str = [NSString stringWithCString: cstr encoding:NSASCIIStringEncoding];
            
            if (inputText.length >= 15)
                break;
            
            if (posDot == NSNotFound || inputText.length - posDot < 3)
                self.inputText = [self.inputText stringByAppendingString:str];
            
            isCurNumberDirty = YES;

            break;
            
        case keyDot:
            if (posDot == NSNotFound)
                self.inputText = [self.inputText stringByAppendingString:@"."];
            isCurNumberDirty = YES;
            break;
            
        case keyDelete:
            if ([inputText length] > 0)
                self.inputText = [inputText substringToIndex:inputText.length - 1];
            else if ([inputText length] == 0) {
                if (isCurNumberDirty)
                    isCurNumberDirty = NO;
                else {
                    // clear all op and operands and start again
                    prevNumber = 0.0;
                    activeOp = opNone;
                }
            }
            break;
            
        case keyPlus:
        case keyMinus:
        case keyMultiply:
        case keyDivide:
            [self pushOp:(Operator) button.tag];
            break;
            
        default:
            break;
    }
    [self syncUi];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    if (!needReset_)
        return;
    needReset_ = NO;
    prevNumber = 0.0;
    curNumber = editingItem ? editingItem.amount : 0.0;
    activeOp = opNone;
    self.inputText = editingItem ? [NSString stringWithFormat:@"%.2f", curNumber] : @"";
    isCurNumberDirty = NO;
    self.uiNotes.text = editingItem ? editingItem.notes : @"";
    self.currentDate = editingItem? editingItem.date : [NSDate date];
    CategoryManager* catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase:NO];
    
    // Initialize the "Pick Photo" area
    if (!editingItem || editingItem.pictureRef == nil || editingItem.pictureRef.length == 0) {
        imageView.image = nil;
        imageView.hidden = YES;
        frameView.hidden = YES;
        imageEditButton.hidden = YES;
        imageButton.hidden = NO;
    }
    else {
        UIImage* image = [[ExpenseManager instance]loadImageNote:editingItem.pictureRef];
        imageView.image = image;
        imageView.hidden = NO;
        frameView.hidden = NO;
        imageButton.hidden = YES;
        imageEditButton.hidden = NO;
    }
    
    imageUpdated_ = NO;
    
    // the maximum date is today
    datePicker.maximumDate = [NSDate date];
    datePicker.date = currentDate;
    
    int catId = editingItem ? editingItem.categoryId : -1;
    [self setSelectedCategory:[NSNumber numberWithInt:catId]];
    [catViewController resetState:catId];
    [self switchFloatingView:numPadView];
    [self syncUi];
}

- (void)viewWillDisappear:(BOOL)animated {

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:catViewController.view];
    catViewController.view.frame = inputPlaceHolder.frame;
    [catViewController loadButtons];
    catViewController.view.hidden = YES;
    catViewController.responder = self;
    catViewController.onCategorySelected = @selector(setSelectedCategory:);
    
    numPadView.frame = inputPlaceHolder.frame;
    [self.view addSubview:numPadView];
    numPadView.hidden = NO;
    
    datePickerView.frame = inputPlaceHolder.frame;
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
    
    activeFloatingView = numPadView;
    
    self.imageNoteViewController = [[UIImageNoteViewController alloc]initWithNibName:@"UIImageNoteViewController" bundle:[NSBundle mainBundle]];
    imageNoteViewController.delegate = self;
}

- (void)onSelectCategory:(id)sender {
    [self switchFloatingView: catViewController.view];
    [catViewController viewDidAppear:YES];
}

- (void)onPickDate:(id)sender {
    UIDatePicker* picker = (UIDatePicker*)[datePickerView viewWithTag:2];
    picker.date = self.currentDate;
    [self switchFloatingView: datePickerView];
}

- (void)onDateChanged:(id)sender {
    UIDatePicker* picker = (UIDatePicker*)sender;
    self.currentDate = picker.date;
    [self syncUi];
}

#pragma mark - image picker delegate
// Image Picker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated: YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissModalViewControllerAnimated: YES];
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    if (!image)
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (!image)
        return;
    
    [imageView setImage:image];
    imageButton.hidden = YES;
    imageEditButton.hidden = NO;
    imageView.hidden = NO;
    frameView.hidden = NO;
    imageUpdated_ = YES;
}

// Navigation Controller Delegate for Image Picker


// Action Sheet For Picking Photo
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex])
        return;
    
    UIImagePickerController* picker = [[[UIImagePickerController alloc]init]autorelease];
    picker.delegate = self;
    
    if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"拍照") {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([actionSheet buttonTitleAtIndex:buttonIndex] == @"用户相册") {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}

- (void)onPickPhoto:(id)sender {
    UIActionSheet* actionSheet = [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"用户相册", nil]autorelease];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView: self.view];
}

#pragma mark - image note view controller delegate

- (void)imageDeleted {
    imageView.image = nil;
    imageView.hidden = YES;
    frameView.hidden = YES;
    imageEditButton.hidden = YES;
    imageButton.hidden = NO;
    imageUpdated_ = YES;
}

- (void)onImageEditButton {
    imageNoteViewController.delegate = self;
    imageNoteViewController.imageNote = imageView.image;
    [self presentModalViewController:imageNoteViewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.uiNotes = nil;
    self.uiNumber = nil;
    self.uiDate = nil;
    self.catViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
