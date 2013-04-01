//
//  PasscodeSettingViewController.m
//  woojuu
//
//  Created by Rome Lee on 12-12-2.
//
//

#import "PasscodeSettingViewController.h"
#import "PasscodeManager.h"

@interface PasscodeSettingViewController ()

@end

@implementation PasscodeSettingViewController

@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onDone {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [table reloadData];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reusableIdentifier = @"PasscodeSettingCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [PasscodeManager isPasscodeEnabled] ? @"关闭密码" : @"开启密码";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"更改密码";
        cell.textLabel.enabled = [PasscodeManager isPasscodeEnabled];
        cell.userInteractionEnabled = [PasscodeManager isPasscodeEnabled];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if ([PasscodeManager isPasscodeEnabled])
            [PasscodeManager turnOffPasscode];
        else
            [PasscodeManager turnOnPasscode];
    }
    else if (indexPath.row == 1) {
        [PasscodeManager changePasscode];
    }
}

@end
