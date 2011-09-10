//
//  UIImageNoteViewController.h
//  woojuu
//
//  Created by Rome Lee on 11-8-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageNoteViewContollerDelegate <NSObject>

@required
- (void)imageDeleted;

@end

@interface UIImageNoteViewController : UIViewController <UIActionSheetDelegate, UIScrollViewDelegate> {
    
}

@property(nonatomic, assign) id<ImageNoteViewContollerDelegate> delegate;
@property(nonatomic, retain) UIImage* imageNote;

@property(nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;

- (IBAction)onDeleteImage;
- (IBAction)onDone;

@end
