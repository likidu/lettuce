//
//  ProgressView.m
//  woojuu
//
//  Created by Lee Rome on 11-12-13.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressLayer

@synthesize progress = _progress;
@synthesize flagProgress = _flagProgress;
@synthesize theme;

- (id)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        if ([[layer class]isSubclassOfClass:[ProgressLayer class]]) {
            ProgressLayer* otherLayer = (ProgressLayer*)layer;
            self.progress = otherLayer.progress;
            self.flagProgress = otherLayer.flagProgress;
            self.theme = otherLayer.theme;
            self.contentsScale = 2.0;
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"] || [key isEqualToString:@"flagProgress"])
        return YES;
    return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
}

@end

@implementation ProgressView

@synthesize progress;
@synthesize flagProgress;
@synthesize activeThemeName;
@synthesize themeDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.themeDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.themeDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc {
    CLEAN_RELEASE(themeDict);
    [super dealloc];
}

+ (Class)layerClass {
    return [ProgressLayer class];
}

- (void)setProgress:(float)value {
    progress = value;
    ((ProgressLayer*)self.layer).progress = value;
}

- (void)setProgress:(float)progressValue animated:(BOOL)animated {
    if (!animated) {
        self.progress = progressValue;
        [self setNeedsDisplay];
        return;
    }
    
    [CATransaction begin];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"progress"];
    animation.duration = 0.4;
    animation.fromValue = [NSNumber numberWithDouble:self.progress];
    animation.toValue = [NSNumber numberWithDouble:progressValue];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addAnimation:animation forKey:@"animateProgress"];
    
    [CATransaction commit];
    
    self.progress = progressValue;
}

- (void)setFlagProgress:(float)value {
    flagProgress = value;
    ((ProgressLayer*)self.layer).flagProgress = value;
}

- (void)setActiveThemeName:(NSString *)themeName {
    CLEAN_RELEASE(activeThemeName);
    activeThemeName = [themeName retain];
    NSDictionary* theme = [self.themeDict objectForKey:activeThemeName];
    if ([[self.layer class]isSubclassOfClass:[ProgressLayer class]])
        ((ProgressLayer*)self.layer).theme = theme;
}

- (void)registerTheme:(NSDictionary *)resDict withName:(NSString *)themeName {
    if (resDict)
        [self.themeDict setObject:resDict forKey:themeName];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSDictionary* theme = [self.themeDict objectForKey:activeThemeName];
    
    UIImage* barStartImage = [theme objectForKey:@"img.bar.start"];
    UIImage* barPatternImage = [theme objectForKey:@"img.bar.pattern"];
    UIImage* barEndImage = [theme objectForKey:@"img.bar.end"];
    UIImage* flagImage = [theme objectForKey:@"img.flag"];
    UIImage* slotImage = [theme objectForKey:@"img.slot"];
    CGRect drawRect;
    CGRect rect = self.bounds;
    ProgressLayer* customLayer = [[layer class]isSubclassOfClass:[ProgressLayer class]] ? (ProgressLayer*)layer : nil;
    double drawingProgress = customLayer.progress;
    if (drawingProgress > 1.0)
        drawingProgress = 1.0;
    
    UIGraphicsPushContext(ctx);
    
    [slotImage drawAtPoint:rect.origin];
    
    if (drawingProgress > 0.0) {
        CGRect innerRect = CGRectInset(rect, 1, 1);
        // draw start
        if (barStartImage) {
            drawRect = innerRect;
            drawRect.size = barStartImage.size;
            [barStartImage drawAtPoint:drawRect.origin];
        }
        
        // draw pattern
        if (barPatternImage) {
            drawRect = CGRectOffset(drawRect, drawRect.size.width, 0.0);
            drawRect.size.width = roundf((innerRect.size.width - barStartImage.size.width - barEndImage.size.width) * drawingProgress);
            [barPatternImage drawInRect:drawRect];
        }
        
        // draw end
        if (barEndImage) {
            drawRect = CGRectOffset(drawRect, drawRect.size.width, 0.0);
            drawRect.size = barEndImage.size;
            [barEndImage drawInRect:drawRect];
        }
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
    
    UIGraphicsPopContext();
}

- (void)drawRect:(CGRect)rect {
    
}

@end
