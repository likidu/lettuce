//
//  CategoryViewController.h
//  hello
//
//  Created by Rome Lee on 11-5-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate <NSObject>

- (void)categorySelected:(NSNumber*)data;

@end

@interface CategoryViewController : UIViewController <UIScrollViewDelegate> {
    BOOL pageControlUsed;
    UIButton* currentSelectedButton;
    int selectedCategoryId;
}

- (IBAction)pageChaged:(id)sender;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) UIView* topCategoryIndicator;

@property (nonatomic, assign) BOOL silent;

- (IBAction)categorySelected:(id)sender;
- (void)loadButtons;
- (void)resetState:(int)selectedCatId;

@property (nonatomic, assign) id<CategoryViewControllerDelegate> delegate;

@end
