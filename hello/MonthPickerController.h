//
//  MonthPickerController.h
//  woojuu
//
//  Created by Rome Lee on 11-8-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MonthPickerControllerDelegate <NSObject>

@required
- (void)monthPicked:(NSDate*)dayOfMonth;

@end


@interface MonthPickerController : UIViewController<UIScrollViewDelegate> {

}

+ (MonthPickerController*)pickerWithMonths:(NSArray*)months;

@property(nonatomic, retain) NSArray* months;
@property(nonatomic, retain) NSArray* labels;
@property(nonatomic, assign) id<MonthPickerControllerDelegate> delegate;

@property(nonatomic, retain) IBOutlet UILabel* sampleLabel;

- (void)reload;
- (void)pickMonth:(NSDate*)dayOfMonth;

@end
