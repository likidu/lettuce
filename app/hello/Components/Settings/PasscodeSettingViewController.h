//
//  PasscodeSettingViewController.h
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import <UIKit/UIKit.h>

@interface PasscodeSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,retain) IBOutlet UITableView* table;

- (IBAction)onDone;

@end
