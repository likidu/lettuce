//
//  FirstExperienceView.h
//  woojuu
//
//  Created by Lee Rome on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationProtocol.h"

@interface FirstExperienceView : UIViewController<NavigationController>

@property(nonatomic,retain) NSArray*                navigationItems;
@property(nonatomic,assign) int                     activeItemIndex;
@property(nonatomic,retain) NSMutableDictionary*    navigationData;

@end
