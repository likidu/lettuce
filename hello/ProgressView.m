//
//  ProgressView.m
//  woojuu
//
//  Created by Lee Rome on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

@synthesize progress;
@synthesize flagProgress;
@synthesize activeThemeName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        themeDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        themeDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [themeDict release];
}

- (void)setProgress:(float)value {
    progress = value;
    [self setNeedsDisplay];
}

- (void)setFlagProgress:(float)value {
    flagProgress = value;
    [self setNeedsDisplay];
}

- (void)setActiveThemeName:(NSString *)themeName {
    [activeThemeName release];
    activeThemeName = [themeName retain];
    [self setNeedsDisplay];
}

- (void)registerTheme:(NSDictionary *)resDict withName:(NSString *)themeName {
    if (resDict)
        [themeDict setObject:resDict forKey:themeName];
}

- (void)drawRect:(CGRect)rect
{
    if (FUZZYEQUAL(progress, 0.0) || progress > 1.0)
        return;
    
    NSDictionary* theme = [themeDict objectForKey:activeThemeName];
    UIImage* barStartImage = [theme objectForKey:@"img.bar.start"];
    UIImage* barPatternImage = [theme objectForKey:@"img.bar.pattern"];
    UIImage* barEndImage = [theme objectForKey:@"img.bar.end"];
    UIImage* flagImage = [theme objectForKey:@"img.flag"];
    CGRect drawRect;
    
    // draw start
    if (barStartImage) {
        drawRect = rect;
        drawRect.size = barStartImage.size;
        [barStartImage drawInRect:drawRect];
    }
    
    // draw pattern
    if (barPatternImage) {
        drawRect = CGRectOffset(drawRect, drawRect.size.width, 0.0);
        drawRect.size.width = roundf((rect.size.width - barStartImage.size.width - barEndImage.size.width) * progress);
        [barPatternImage drawAsPatternInRect:drawRect];
    }
    
    // draw end
    if (barEndImage) {
        drawRect = CGRectOffset(drawRect, drawRect.size.width, 0.0);
        drawRect.size = barEndImage.size;
        [barEndImage drawInRect:drawRect];
    }
    
    // draw flag
    if (flagImage){
        drawRect = rect;
        drawRect.size = flagImage.size;
        float offsetX = barStartImage.size.width - flagImage.size.width * 0.5;
        offsetX += roundf((rect.size.width - barStartImage.size.width - barEndImage.size.width) * flagProgress);
        drawRect = CGRectOffset(drawRect, offsetX, rect.size.height - flagImage.size.height);
        [flagImage drawInRect:drawRect];
    }
}

@end
