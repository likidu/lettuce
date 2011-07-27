//
//  PlotView.m
//  hello
//
//  Created by Rome Lee on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PlotView.h"

PlotViewDefaultTheme* g_defaultTheme = nil;

@implementation PlotView

@synthesize plotViewStyle;
@synthesize plotDelegate;
@synthesize dataSource;
@synthesize theme;

- (void)scaleView:(UIPinchGestureRecognizer*)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self];

}

- (void)setDefaults {
    self.delegate = nil;
    self.dataSource = nil;
    minValue_ = 0;
    maxValue_ = 0;
    dataSets_ = nil;
    self.plotViewStyle = PlotViewStyleBarChart;
    self.theme = [PlotViewDefaultTheme defaultTheme];
    self.delegate = self;
    [self setContentSize:CGSizeMake([theme widthOfBlock] * 7, 300)];
    
    UIPinchGestureRecognizer* gesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(scaleView:)];
    [self addGestureRecognizer:gesture];
    [gesture release];
}

- (id)init {
    self = [super init];
    [self setDefaults];   
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setDefaults];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setDefaults];
    return self;
}

- (void)reloadData {
    if (!dataSource)
        return;
    int numDataSets = [dataSource numberOfDataSetInPlotView:self];
    NSMutableArray* sets = [NSMutableArray arrayWithCapacity:numDataSets];
    
    minValue_ = 0, maxValue_ = 0;
    for (int i = 0; i < numDataSets; i++) {
        int numItems = [dataSource plotView:self numberOfItemsInDataSet:i];
        NSMutableArray* items = [NSMutableArray arrayWithCapacity:numItems];
        for (int j = 0; j < numItems; j++) {
            float value = [dataSource plotView:self valueOfItem:j inDataSet:i];
            if (value < minValue_)
                minValue_ = value;
            else if (value > maxValue_)
                maxValue_ = value;
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.theme == nil) {
        [super drawRect:rect];
        return;
    }
    
    // fill background
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [[theme colorForBackground]setFill];
    CGContextFillRect(context, rect);
    NSLog(@"Bounds %f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    // fill base area
    [[theme colorForBaseArea] setFill];
    CGRect frame = [self frame];
    CGRect rcBaseArea = CGRectMake(0, 0, [self contentSize].width, [theme heightOfBaseArea]);
    rcBaseArea.origin.y = CGRectGetMaxY(frame) - [theme heightOfBaseArea];

    CGContextFillRect(context, rcBaseArea);
    
    // set font
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    
    NSArray* names = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", nil];
    NSArray* values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1399], 
                       [NSNumber numberWithFloat:1100], 
                       [NSNumber numberWithFloat:1024], 
                       [NSNumber numberWithFloat:870], 
                       [NSNumber numberWithFloat:900], 
                       [NSNumber numberWithFloat:300], 
                       [NSNumber numberWithFloat:20], nil];
    float maxValue = 1399;
    float barWidth = [theme widthOfBar];
    
    for (int i = 0; i < names.count; i++) {
        CGRect rcBlock = CGRectMake([theme widthOfBlock] * i, 0, [theme widthOfBlock], rect.size.height - rcBaseArea.size.height);
        if (!CGRectIntersectsRect(rcBlock, rect))
            continue;
        NSString* name = [names objectAtIndex:i];
        float value = [[values objectAtIndex:i]floatValue];
        // draw the bar
        CGPoint origin;
        origin.x = CGRectGetMidX(rcBlock) - barWidth * 0.5;
        origin.y = rcBlock.size.height * (1.0 - value / maxValue);
        CGSize size;
        size.width = barWidth;
        size.height = rcBlock.size.height - origin.y;
        CGRect rcBar;
        rcBar.origin = origin;
        rcBar.size = size;
        [[theme colorForItem:i inDataSet:0]setFill];
        CGContextFillRect(context, rcBar);
        // draw item name
        //const char* text = [name UTF8String];
        //int len = strlen(text);
        [[theme textColorForItem:0 inDataSet:0]setFill];
        CGRect rcText = CGRectIntersection(rcBlock, rcBaseArea);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        rcText.size.height = rcBaseArea.size.height;
        //CGContextSetTextDrawingMode(context, kCGTextInvisible);
        //CGContextShowTextAtPoint(context, 0, 0, text, len);
        //CGPoint textSize = CGContextGetTextPosition(context);
        //CGContextSetTextDrawingMode(context, kCGTextFill);
        //CGPoint midPoint = CGPointMake(CGRectGetMidX(rcText), CGRectGetMidY(rcText));
        [name drawInRect:rcText withFont:[theme fontForItem:0 inDataSet:0] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
        //CGContextShowTextAtPoint(context, midPoint.x - textSize.x / 2, midPoint.y - textSize.y / 2, text, len);
    }
    
    CGContextRestoreGState(context);
    
    [[UIColor redColor]setFill];
    CGContextFillRect(context, CGRectMake(0, 0, 20, 10));
    
    [super drawRect:rect];
}

// scrolling
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation PlotViewDefaultTheme

+ (PlotViewDefaultTheme *)defaultTheme {
    if (g_defaultTheme == nil)
        g_defaultTheme = [[PlotViewDefaultTheme alloc]init];
    return g_defaultTheme;
}

- (UIColor*)colorForItem:(int)item inDataSet:(int)dataSet {
    return [UIColor blueColor];
}

- (UIFont*)fontForItem:(int)item inDataSet:(int)dataSet {
    return [UIFont fontWithName:@"Helvetica" size: 12.0];
}

- (UIColor*)textColorForItem:(int)item inDataSet:(int)dataSet {
    return [UIColor whiteColor];
}

- (float)widthOfBar {
    return 30.0;
}

- (float)radiusOfNode {
    return 10.0;
}

- (float)widthOfBlock {
    return 80.0;
}

- (float)heightOfBaseArea {
    return 40.0;
}

- (UIColor *)colorForBackground {
    return [UIColor blackColor];
}

- (UIColor *)colorForBaseArea {
    return [[UIColor whiteColor]colorWithAlphaComponent:0.2];
}

@end
