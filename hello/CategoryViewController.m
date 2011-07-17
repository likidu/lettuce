//
//  CategoryViewController.m
//  hello
//
//  Created by Rome Lee on 11-5-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryManager.h"

CGSize categoryButtonSize = {60, 72};
#define CAT_PER_ROW 4
#define ROW_PER_PAGE 2

@implementation CategoryViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize onCategorySelected;
@synthesize responder;
@synthesize topCategoryIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)removeAllCategoryButtons {
    NSArray* buttons = [scrollView subviews];
    for (UIButton* button in buttons)
        [button removeFromSuperview];
    currentSelectedButton = nil;
    selectedCategoryId = 0;
}

- (void)loadButtons {
    [self removeAllCategoryButtons];
    
    // calculate capacities
    CGRect frame = scrollView.frame;
    
    // calculate spaces between rows/columns to make sure the contents are in the center
    float spaceRows = frame.size.height - categoryButtonSize.height * ROW_PER_PAGE;
    spaceRows /= ROW_PER_PAGE + 1.0;
    float spaceColumns = frame.size.width - categoryButtonSize.width * CAT_PER_ROW;
    spaceColumns /= CAT_PER_ROW + 1.0;
    
    // colors
    UIColor * colorNormal = [UIColor blackColor];
    UIColor * colorHighlight = [UIColor blueColor];
    
    CategoryManager* catMan = [CategoryManager instance];
    [catMan loadCategoryDataFromDatabase:NO];

    for (int page = 0; page < catMan.topCategoryCollection.count; page++) {
        Category* topCat = [catMan.topCategoryCollection objectAtIndex:page];
        NSArray* subCats = [catMan getSubCategoriesWithCategoryId:topCat.categoryId];
        for (int i = 0; i < subCats.count; i ++) {
            Category* cat = [subCats objectAtIndex:i];
            int column = i % CAT_PER_ROW;
            int row = i / CAT_PER_ROW;
            CGRect buttonFrame;
            buttonFrame.size = categoryButtonSize;
            buttonFrame.origin.x = frame.size.width * page + spaceColumns * (column + 1) + column * categoryButtonSize.width;
            buttonFrame.origin.y = spaceRows * (row + 1) + row * categoryButtonSize.height;
            
            UIImage* image = [catMan iconNamed:cat.iconName];
            if (!image)
                continue;
            UIButton* button = [UIButton buttonWithType: UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize: 12];
            [button setTitle:cat.categoryName forState:UIControlStateNormal];
            [button setTitleColor:colorNormal forState:UIControlStateNormal];
            [button setTitleColor:colorHighlight forState:UIControlStateHighlighted];
            [button setTitleColor:colorHighlight forState:UIControlStateSelected];

            [button setImage:image forState:UIControlStateNormal];
            [button setImage:[catMan iconNamed:cat.hilitedIconName] forState:UIControlStateHighlighted];
            [button setImage:[catMan iconNamed:cat.hilitedIconName] forState:UIControlStateSelected];
            button.showsTouchWhenHighlighted = YES;
            button.frame = buttonFrame;
            button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
            button.titleLabel.textAlignment = UITextAlignmentCenter;
            CGRect titleFrame = [button titleRectForContentRect:buttonFrame];
            CGRect imageFrame = [button imageRectForContentRect:buttonFrame];
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageFrame.size.width, -imageFrame.size.height, 0.0);
            button.imageEdgeInsets = UIEdgeInsetsMake(-titleFrame.size.height, 0.0, 0.0, -titleFrame.size.width);
            [button addTarget:self action:@selector(categorySelected:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = cat.categoryId;
            [scrollView addSubview:button];
        }
    }

    pageControl.numberOfPages = catMan.topCategoryCollection.count;
    pageControl.currentPage = 0;
    
    scrollView.contentSize = CGSizeMake(frame.size.width * catMan.topCategoryCollection.count, frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    currentSelectedButton = nil;
    selectedCategoryId = 0;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    frame.size.height = 30;
    UILabel* label = [[[UILabel alloc]initWithFrame:frame]autorelease];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.hidden = YES;
    self.topCategoryIndicator = label;

    [self.view.superview insertSubview:label belowSubview:self.view];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueChangeSetting context:nil];
    //[self.pageControl addObserver:self forKeyPath:@"currentPage" options:NSKeyValueChangeSetting context:nil];
}

- (void)showTopCategoryIndicator {
    static int currentShowingPage = -1;
    if (pageControl.currentPage == currentShowingPage)
        return;
    currentShowingPage = pageControl.currentPage;
    
    UILabel* label = (UILabel*) self.topCategoryIndicator;
    CategoryManager* catMan = [CategoryManager instance];
    Category* cat = [catMan.topCategoryCollection objectAtIndex:pageControl.currentPage];
    label.text = cat.categoryName;
    label.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        topCategoryIndicator.frame = CGRectOffset(topCategoryIndicator.frame, 0, -30);
    }completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.2 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionTransitionNone|UIViewAnimationOptionBeginFromCurrentState animations:^{
                topCategoryIndicator.frame = CGRectOffset(topCategoryIndicator.frame, 0, 30);
            } completion:^(BOOL finished){
                if (finished)
                    label.hidden = YES;
            }];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [self showTopCategoryIndicator];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.view &&  keyPath == @"frame") {
        [self.topCategoryIndicator removeFromSuperview];
        CGRect frame = self.view.frame;
        frame.size.height = 30;
        self.topCategoryIndicator.frame = frame;
        [self.view.superview insertSubview:self.topCategoryIndicator belowSubview:self.view];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.topCategoryIndicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)categorySelected:(id)sender {
    UIButton* button = sender;
    button.selected = YES;
    if (currentSelectedButton != nil)
        currentSelectedButton.selected = NO;
    currentSelectedButton = button;
    NSLog(@"%@", button.titleLabel.text);
    [self.responder performSelector:self.onCategorySelected withObject:[NSNumber numberWithInt: button.tag]];
}

- (void)resetState:(int)selectedCatId {
    for (UIButton* button in scrollView.subviews) {
        if (button.tag == selectedCategoryId) {
            button.selected = NO;
            button.selected = YES;
        }
        else
            button.selected = NO;
    }
}

- (void)pageChaged:(id)sender {
    int page = pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
    
    [self showTopCategoryIndicator];
}

- (void)scrollViewDidScroll:(UIScrollView *)view {
    
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = view.frame.size.width;
    int page = floor((view.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
    
    [self showTopCategoryIndicator];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}

@end
