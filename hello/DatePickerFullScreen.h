//
//  DatePickerFullScreen.h
//  hello
//
//  Created by Rome Lee on 11-5-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerFullScreen : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
    
}

@property(nonatomic, retain) NSObject* object;
@property(nonatomic) SEL reactor;

+ (DatePickerFullScreen*)instance;
- (void)presentOnView:(UIView*)view;

- (IBAction)onEndEdit:(id)sender;

@end
