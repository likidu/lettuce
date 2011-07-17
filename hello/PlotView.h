//
//  PlotView.h
//  hello
//
//  Created by Rome Lee on 11-7-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlotView;

@protocol PlotViewDataSource <NSObject>

@required

- (int)numberOfDataSetInPlotView:(PlotView*)plotView ;
- (NSString*)plotView:(PlotView*)plotView nameOfDataSet:(int)dataSet;

- (int)plotView:(PlotView*)plotView numberOfItemsInDataSet:(int)dataSet;
- (NSString*)plotView:(PlotView*)plotView nameOfItem:(int)item inDataSet:(int)dataSet;
- (float)plotView:(PlotView*)plotView valueOfItem:(int)item inDataSet:(int)dataSet;
- (NSString*)plotView:(PlotView*)plotView displayValueOfItem:(int)item inDataSet:(int)dataSet;

@end

@protocol PlotViewDelegate <NSObject>

@optional
- (void)zoomInPlotView:(PlotView*)plotView;
- (void)zoomOutPlotView:(PlotView*)plotView;

@end

@protocol PlotViewTheme <NSObject>

@required

- (UIColor*)colorForBackground;
- (UIColor*)colorForBaseArea;
- (UIColor*)colorForItem:(int)item inDataSet:(int)dataSet;
- (UIFont*)fontForItem:(int)item inDataSet:(int)dataSet;
- (UIColor*)textColorForItem:(int)item inDataSet:(int)dataSet;
- (float)widthOfBlock;
- (float)heightOfBaseArea;
- (float)widthOfBar;
- (float)radiusOfNode;

@end

@interface PlotViewDefaultTheme : NSObject<PlotViewTheme> {
@private
    
}

+ (PlotViewDefaultTheme*)defaultTheme;

@end

typedef enum {
    PlotViewStyleBarChart = 0,
    PlotViewStyleLineChart
}PlotViewStyle;

@interface PlotView : UIScrollView<UIScrollViewDelegate> {
    float minValue_;
    float maxValue_;
    NSMutableArray* dataSets_;
}

@property PlotViewStyle plotViewStyle;
@property (nonatomic, assign) id<PlotViewDataSource> dataSource;
@property (nonatomic, assign) id<PlotViewDelegate> plotDelegate;
@property (nonatomic, assign) id<PlotViewTheme> theme;

- (void)reloadData;

@end
