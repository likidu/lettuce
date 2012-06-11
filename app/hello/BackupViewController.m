//
//  BackupViewController.m
//  woojuu
//
//  Created by Zhao Yingbin on 12-6-4.
//  Copyright (c) 2012年 Microsoft. All rights reserved.
//

#import "BackupViewController.h"

@implementation BackupViewController

- (id)init
{
    return [self initWithNibName:@"BackupViewController.xib" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Customized init.
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 2;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* backupCellId = @"backupCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:backupCellId];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:backupCellId] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row) 
        {
            case 0:
                cell.textLabel.text = @"备份";
                break;
                
            case 1:
                cell.textLabel.text = @"恢复";
                break;
                
            default:
                cell.textLabel.text = @"";
        }
    }
    else
    {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

@end
