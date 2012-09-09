//
//  ActiveAccountingReminderViewController.m
//  woojuu
//
//  Created by Liangying Wei on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Utility.h"
#import "AccountingReminderViewController.h"
#import "ConfigurationManager.h"

@interface AccountingReminderViewController ()
@end

@implementation AccountingReminderViewController
@synthesize accountingReminderTableView;
@synthesize detailedReminderTableView;
@synthesize yesNoSwitch;
@synthesize dailyPicker;
@synthesize weeklyPicker;
@synthesize itemPicker;
@synthesize reminderTypeData;
@synthesize dailyTimeData;
@synthesize weeklyData;
@synthesize activeFloatingView;
@synthesize currentReminderType;
@synthesize currentWeekIndex;
@synthesize currentTimeIndex;
@synthesize reminderTimeMask;

const int ReminderIntervalMinutes = 30;
const int BITNUMBER = 16;

+ (AccountingReminderViewController*) createInstance{
    AccountingReminderViewController* instance = [[AccountingReminderViewController alloc]initWithNibName:@"ActiveAccountingReminderViewController" bundle:[NSBundle mainBundle]];
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Event handler

- (IBAction)onReturn:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)onSwitch:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:yesNoSwitch.on forKey:REMINDER_SWITCH_KEY];
    [accountingReminderTableView reloadData];

    if (!yesNoSwitch.on) {
        cancelNotifications();
        detailedReminderTableView.hidden = YES;
    } else{
        
        [self setNotification];
        detailedReminderTableView.hidden = NO;
    }
    [self hidePickers];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.reminderTypeData = [NSArray arrayWithObjects:@"每日提醒",@"每周提醒", nil];
    self.dailyTimeData = getTimeArrayWithMinutesInteval(ReminderIntervalMinutes);
    self.weeklyData = getWeekdayStringArray();
    self.currentReminderType = [[NSUserDefaults standardUserDefaults]integerForKey:REMINDER_TYPE_KEY];
    self.currentTimeIndex = 0;
    self.currentWeekIndex = 0;
    // The formula for Mask: Mask = WeekIndex << 16 + TimeIndex
    // Assume TimeIndex is less than 1000 (currently is 48)
    self.reminderTimeMask = [[NSUserDefaults standardUserDefaults]doubleForKey:REMINDER_TIME_KEY];
    self.reminderTimeMask = self.reminderTimeMask ? self.reminderTimeMask : 0;
    [self setCurrentIndexFromReminderMask:self.reminderTimeMask];
    [self hidePickers];
}

- (void)viewDidUnload
{
    [self setAccountingReminderTableView:nil];
    [self setYesNoSwitch:nil];
    [self setDetailedReminderTableView:nil];
    [self setItemPicker:nil];
    [self setActiveFloatingView:nil];
    [self setDailyPicker:nil];
    [self setWeeklyPicker:nil];
    [self setActiveFloatingView:nil];
    [self setReminderTypeData:nil];
    [self setDailyTimeData:nil];
    [self setWeeklyData:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    yesNoSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:REMINDER_SWITCH_KEY];    
    detailedReminderTableView.hidden = !yesNoSwitch.on;  
    [self.itemPicker selectRow:self.currentReminderType inComponent:0 animated:NO];
    [self.weeklyPicker selectRow:self.currentWeekIndex inComponent:0 animated:NO];
    [self.weeklyPicker selectRow:self.currentTimeIndex inComponent:1 animated:NO];
    [self.dailyPicker selectRow:self.currentTimeIndex inComponent:0 animated:NO];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [accountingReminderTableView release];
    [yesNoSwitch release];
    [detailedReminderTableView release];
    [itemPicker release];
    [activeFloatingView release];
    [dailyPicker release];
    [weeklyPicker release];
    [reminderTypeData release];
    [activeFloatingView release];
    [dailyTimeData release];
    [weeklyData release];
    [super dealloc];
}

#pragma mark - private utility

- (void)hidePickers{
    self.activeFloatingView = nil;
    self.dailyPicker.hidden = YES;
    self.weeklyPicker.hidden = YES;
    self.itemPicker.hidden = YES;
    [self.detailedReminderTableView deselectRowAtIndexPath:self.detailedReminderTableView.indexPathForSelectedRow animated:false];
}

-(NSUInteger)getReminderMaskFromReminderIndex:(NSUInteger) weekIndex:(NSUInteger) timeIndex{
    return (weekIndex << BITNUMBER) + timeIndex;
}

-(NSString *)getTitleFromReminderMask:(NSUInteger) reminderMask:(enum ReminderType) reminderType{
    
    NSUInteger weekIndex = reminderMask >> BITNUMBER;
    NSUInteger timeIndex = (reminderMask - (weekIndex << BITNUMBER));
    
    if (reminderType == Daily) {
        return [NSString stringWithFormat:@"%@", [dailyTimeData objectAtIndex:timeIndex]];
    }
    
    return [NSString stringWithFormat:@"%@, %@", [weeklyData objectAtIndex:weekIndex], [dailyTimeData objectAtIndex:timeIndex]];
} 

-(void)setCurrentIndexFromReminderString:(NSString *)reminderString{
    NSArray * tempArray = [reminderString componentsSeparatedByString:@", "];
    if (tempArray.count == 1) {
        self.currentTimeIndex = [self.dailyTimeData indexOfObject:[tempArray objectAtIndex:(NSUInteger)0]];
    }else if (tempArray.count == 2){
        self.currentWeekIndex = [self.weeklyData indexOfObject:[tempArray objectAtIndex:(NSUInteger)0]];
        self.currentTimeIndex = [self.dailyTimeData indexOfObject:[tempArray objectAtIndex:(NSUInteger)1]];
    }
}

-(void)setCurrentIndexFromReminderMask:(NSUInteger)reminderMask{
    self.currentWeekIndex = reminderMask >> BITNUMBER;
    self.currentTimeIndex = reminderMask - (currentWeekIndex << BITNUMBER);
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:accountingReminderTableView]){
        if (section == 0) {
            return 1;
        }
        
        return 0;
    }
    else if ([tableView isEqual: detailedReminderTableView]){
        if (section == 0){
            return 2;
        }
        
        return 0;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual: accountingReminderTableView]){
        return 1;
        
    }
    else if ([tableView isEqual: detailedReminderTableView]){
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == accountingReminderTableView){
        static NSString* kAccountingReminderCellId = @"AccountingReminderCell";
    
        UITableViewCell* cell = [accountingReminderTableView dequeueReusableCellWithIdentifier:kAccountingReminderCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAccountingReminderCellId]autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                cell.textLabel.text = @"记帐提醒";
                cell.accessoryView = yesNoSwitch;
            }
        }
        
        return cell;
    }
    else if (tableView == detailedReminderTableView){
        static NSString* kDetailedReminderCellId = @"DetailedReminderCell";
        
        UITableViewCell* cell = [accountingReminderTableView dequeueReusableCellWithIdentifier:kDetailedReminderCellId];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kDetailedReminderCellId]autorelease];
        }
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0){
                cell.textLabel.text = @"提醒周期";
                cell.detailTextLabel.text = [self.reminderTypeData objectAtIndex:self.currentReminderType];
                //[self.dataPicker objectAtIndex:[self.itemPicker selectedRowInComponent:0]];
            }
            else if (indexPath.row == 1){
                cell.textLabel.text = @"时间";
                cell.detailTextLabel.text = [self getTitleFromReminderMask:self.reminderTimeMask:self.currentReminderType];
            }
        }
        
        return cell;
    }   
    
    return Nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == detailedReminderTableView){
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                [self switchFloatingView:itemPicker];
            }
            else if (indexPath.row == 1){
                if (self.currentReminderType == Daily) { 
                    [self.dailyPicker selectRow:self.currentTimeIndex inComponent:0 animated:NO];
                    [self switchFloatingView:dailyPicker];
                }else if (self.currentReminderType == Weekly){                    
                    [self.weeklyPicker selectRow:self.currentTimeIndex inComponent:1 animated:NO];
                    [self switchFloatingView:weeklyPicker];
                }  
            }
        }
    }
    else if (tableView == accountingReminderTableView) {
        [self.accountingReminderTableView deselectRowAtIndexPath:self.accountingReminderTableView.indexPathForSelectedRow animated:false];
    }
}

- (void)switchFloatingView:(UIView *) view{
    if (activeFloatingView == view)
        return;
    if (activeFloatingView) {
        activeFloatingView.hidden = YES;
    }
    
    [self presentView:view];   
    
    activeFloatingView = view;
}

- (void)presentView:(UIView*)view {
    [CATransaction begin];
    CATransition* animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.2;
    view.hidden = NO;
    [view.layer addAnimation:animation forKey:@""];
    [CATransaction commit];
}

#pragma mark - Picker view 
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == weeklyPicker){
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == itemPicker) {
        return 2;
    }else if (pickerView == dailyPicker){
        return 48;
    }else if (pickerView == weeklyPicker){
        if (component == 1) {
            return 48;
        }
        return 7;
    }
    return 1;
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == itemPicker) {
        return [self.reminderTypeData objectAtIndex:row];
    }else if (pickerView == dailyPicker){
        NSString * string = [self.dailyTimeData objectAtIndex:row];
        return string;
    }else if (pickerView == weeklyPicker){
        if (component == 0) {
            return [self.weeklyData objectAtIndex:row];
        }else if (component == 1){
            return [self.dailyTimeData objectAtIndex:row];
        }
    }
    return nil;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == itemPicker) {
        self.currentReminderType = row;
        [[NSUserDefaults standardUserDefaults]setInteger:self.currentReminderType forKey:REMINDER_TYPE_KEY];
    }else if(pickerView == dailyPicker){
        self.currentTimeIndex = row;
    }else if(pickerView == weeklyPicker){
        if (component == 0){ 
            self.currentWeekIndex = row;
        }else {
            self.currentTimeIndex = row;
        }
    }
    
    self.reminderTimeMask = [self getReminderMaskFromReminderIndex:self.currentWeekIndex :self.currentTimeIndex];
    [[NSUserDefaults standardUserDefaults]setDouble:self.reminderTimeMask forKey:REMINDER_TIME_KEY];
    [self setNotification];
    [self.detailedReminderTableView reloadData];    
}

-(void) setNotification{
    NSDate* currentTime = dateFromFormatString([self.dailyTimeData objectAtIndex:self.currentTimeIndex], @"HH:mm", [NSTimeZone localTimeZone]);
    NSUInteger hour = [formatDateToString(currentTime, @"HH", [NSTimeZone localTimeZone]) integerValue];
    NSUInteger minute = [formatDateToString(currentTime, @"mm", [NSTimeZone localTimeZone]) integerValue];
    if (currentReminderType == Daily) {
        // -1 to indicate the Type is Daily
        scheduleNotificationWithItem(-1, hour, minute);
    }else if (currentReminderType == Weekly){
        // weekday starts at 1
        scheduleNotificationWithItem(self.currentWeekIndex + 1, hour, minute);
    }
    
}
@end
