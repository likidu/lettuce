//
//  CategoryViewController.h
//  hello
//
//  Created by Rome Lee on 11-5-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryViewController : UIViewController <UIScrollViewDelegate> {
    BOOL pageControlUsed;
    UIButton* currentSelectedButton;
    int selectedCategoryId;
}

- (IBAction)pageChaged:(id)sender;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) UIView* topCategoryIndicator;

- (IBAction)categorySelected:(id)sender;
- (void)loadButtons;
- (void)resetState:(int)selectedCatId;

@property (nonatomic, retain) NSObject* responder;
@property (nonatomic) SEL onCategorySelected;

@end
