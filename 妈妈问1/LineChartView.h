//
//  LineChartView.h
//  g
//
//  Created by netshow on 15/2/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineChartView : UIView

// Margin of the chart
@property (nonatomic, readwrite) CGFloat margin;

@property (nonatomic, readonly) CGFloat axisWidth;
@property (nonatomic, readonly) CGFloat axisHeight;

@property (nonatomic, readonly) CGFloat axisWidth1;
@property (nonatomic, readonly) CGFloat axisHeight1;

// Decoration parameters, let you pick the color of the line as well as the color of the axis
@property (nonatomic, readwrite) UIColor* axisColor;
@property (nonatomic, readwrite) UIColor* color;

@property (strong, nonatomic) NSArray *x;
@property (strong, nonatomic) NSArray *y;

@property (strong, nonatomic) NSArray *bzValue;
@property(strong,nonatomic)NSArray *bzValuemin;

- (void)setChartData:(NSArray *)chartData;


@end
