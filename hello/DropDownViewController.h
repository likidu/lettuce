//
//  DropDownViewController.h
//  hello
//
//  Created by Rome Lee on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownViewDelegate <NSObject>

- (void)itemPicked:(NSObject*)item atIndex:(int)index;

@end

typedef enum {
    DropDownListPositionLeft,
    DropDownListPositionRight,
    DropDownListPositionTop,
    DropDownListPositionDown
    }DropDownListPosition;

@interface DropDownViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
}

+ (void)presentDropDownList:(NSArray*)list withDelegate:(id)delegate targetView:(UIView*)view atPosition:(DropDownListPosition)position withSize:(CGSize)size;

@property(nonatomic, assign) id<DropDownViewDelegate> dropDownViewDelegate;
@property(nonatomic, retain) NSArray* listData;
@property(nonatomic, retain) UIView* targetView;
@property(nonatomic, assign) DropDownListPosition position;
@property(nonatomic, assign) CGSize listSize;

@property(nonatomic, retain) IBOutlet UIView* listView;

@end
