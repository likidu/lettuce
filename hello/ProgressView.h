//
//  ProgressView.h
//  woojuu
//
//  Created by Lee Rome on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView {
    NSMutableDictionary* themeDict;
}

@property(nonatomic,assign) float progress;
@property(nonatomic,assign) float flagProgress;
@property(nonatomic,retain) NSString* activeThemeName;

- (void)registerTheme:(NSDictionary*)resDict withName:(NSString*)themeName;

@end
