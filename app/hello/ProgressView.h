//
//  ProgressView.h
//  woojuu
//
//  Created by Lee Rome on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProgressLayer : CALayer

@property(nonatomic,assign) double progress;
@property(nonatomic,assign) double flagProgress;
@property(nonatomic,retain) NSDictionary* theme;

@end

@interface ProgressView : UIView {
    NSMutableDictionary* themeDict;
}

@property(nonatomic,assign) float progress;
@property(nonatomic,assign) float flagProgress;
@property(nonatomic,retain) NSString* activeThemeName;
@property(nonatomic,retain) NSMutableDictionary* themeDict;

- (void)registerTheme:(NSDictionary*)resDict withName:(NSString*)themeName;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
