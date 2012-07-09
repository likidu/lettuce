//
//  AboutViewController.h
//  hello
//
//  Created by Rome Lee on 11-8-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MFMailComposeViewController.h"

@interface AboutViewController : UIViewController<MFMailComposeViewControllerDelegate> {
    
}

- (IBAction)onOk;
- (IBAction)onWebsite;
- (IBAction)onWeibo;
- (IBAction)onSupport;
- (IBAction)onRate;

@property(nonatomic,retain) IBOutlet UIView* contentView;
@property(nonatomic,retain) IBOutlet UIScrollView* scrollView;

@end
