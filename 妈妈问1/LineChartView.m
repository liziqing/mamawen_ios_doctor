//
//  LineChartView.m
//  g
//
//  Created by netshow on 15/2/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView()

@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic) CGFloat min;
@property (nonatomic) CGFloat max;

@end

@implementation LineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setDefaultParameters];
    }
    return self;
}

- (void)setDefaultParameters
{
    _color = [UIColor colorWithRed:0.18f green:0.67f blue:0.84f alpha:1.0f];

    _axisWidth = self.frame.size.width ;
    _axisHeight = self.frame.size.height;

    _axisWidth1=30;
    _axisHeight1=30;
    
    _axisColor = [UIColor whiteColor];
}

#pragma mark 绘制网格
- (void)drawRect:(CGRect)rect {
    [self drawGrid];
}

//绘制网格
- (void)drawGrid
{
//---------------x轴第一条线
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 0);
    CGContextSetStrokeColorWithColor(ctx, [[[UIColor whiteColor]colorWithAlphaComponent:0.3] CGColor]);
    
    //y轴
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, _axisHeight);
    CGContextStrokePath(ctx);
    
//    //x轴
//    CGContextMoveToPoint(ctx, _margin, _axisHeight + _margin);
//    CGContextAddLineToPoint(ctx, _axisWidth + _margin, _axisHeight + _margin);
//    CGContextStrokePath(ctx);

    // draw grid   x
    for(int i=0;i<self.x.count;i++) {
        CGContextSetLineWidth(ctx, 0);
        
        CGPoint point = CGPointMake(i*(_axisWidth1),0);
        
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, point.x, _axisHeight);
        CGContextStrokePath(ctx);
    }
    
    //y轴
    for(int i=0;i<self.y.count;i++) {
        CGContextSetLineWidth(ctx, 0.5);
        
        CGPoint point = CGPointMake(0, i*(_axisHeight1));
        
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, _axisWidth , point.y);
        CGContextStrokePath(ctx);
    }
    
}

- (void)setChartData:(NSArray *)chartData
{
    _data = [NSMutableArray arrayWithArray:chartData];
    
    _min = MAXFLOAT;
    _max = -MAXFLOAT;
    
    for(int i=0;i<_data.count;i++) {
        NSNumber* number = _data[i];
        if([number floatValue] < _min)
            _min = [number floatValue];
        
        if([number floatValue] > _max)
            _max = [number floatValue];
    }
    
    // No data
    if(isnan(_max)) {
        _max = 1;
    }
    if(self.x.count) {
        for(int i=0;i<self.x.count;i++) {
            CGPoint p = CGPointMake(_axisWidth1*i, _axisHeight);
            
            NSString* text =[NSString stringWithFormat:@"%@",self.x[i]];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(p.x, p.y + 2, 20, _axisHeight1)];
            label.text = text;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
            
            [self addSubview:label]; //x轴坐标
        }
    }
    [self strokeChart];   //绘制图表
    [self setNeedsDisplay];
}

//绘制图形  --区域空间
- (void)strokeChart
{
    if([_bzValue count] == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    
    for(int i=1;i<_bzValue.count;i++) {
     
        CGPoint p1 = CGPointMake((i-1)* (_axisWidth1),_axisHeight-[self.bzValue[i-1]floatValue]);
        CGPoint p2 = CGPointMake(i *_axisWidth1, _axisHeight-[self.bzValue[i]floatValue]);
        
        CGPoint p3=CGPointMake((i-1)*_axisWidth1, _axisHeight-[self.bzValuemin[i-1]floatValue]);
        CGPoint p4=CGPointMake(i* _axisWidth1, _axisHeight-[self.bzValuemin[i]floatValue]);
        
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:p4];
        [fill addLineToPoint:p3];
        
    }
    
//---------点
//    [path moveToPoint:CGPointMake(_margin,_axisHeight-(_axisHeight/(self.max)*([_y[0] floatValue]))+_margin)];
//    
//    for(int i=0;i<_x.count;i++) {
//        [path addLineToPoint:CGPointMake(_margin + i * (30),_axisHeight- (15*([_y[i] floatValue]))+_margin)];
//        
//        CGPoint point1=CGPointMake(_margin + i * (30),_axisHeight- (15*i)+_margin);
//        
//        UIImageView *dianimageview=[[UIImageView alloc]initWithFrame:CGRectMake(point1.x-2, point1.y-2, 4, 4)];
//        dianimageview.backgroundColor=[UIColor whiteColor];
//        dianimageview.layer.cornerRadius=2;
//        dianimageview.layer.masksToBounds=YES;
//        
//        [self addSubview:dianimageview];
//
//    }
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.frame = self.bounds;
    fillLayer.bounds = self.bounds;
    fillLayer.path = fill.CGPath;
    fillLayer.strokeColor = nil;
    fillLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.25].CGColor;
    fillLayer.lineWidth = 0;
    fillLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:fillLayer];  //填满
    

    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 0.25;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.toValue = (id)fill.CGPath;

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.25;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.toValue = (__bridge id)(path.CGPath);
    
    
    [self strokeChart1];
}



//---------用户线条
- (void)strokeChart1
{
    if([_data count] == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    UIBezierPath* fill = [UIBezierPath bezierPath];
    
    for(int i=1;i<_data.count;i++) {
        CGPoint p1 = CGPointMake((i-1) * _axisWidth1,_axisHeight-([_data[i-1] floatValue]));
        
        CGPoint p2 = CGPointMake( i *_axisWidth1, _axisHeight-([_data[i] floatValue]));
        
        [fill moveToPoint:p1];
        [fill addLineToPoint:p2];
        [fill addLineToPoint:CGPointMake(p2.x, _axisHeight)];
        [fill addLineToPoint:CGPointMake(p1.x, _axisHeight)];
    }
 
    [path moveToPoint:CGPointMake(0,_axisHeight-[_data[0] floatValue])];
    
    for(int i=0;i<_data.count;i++) {
        [path addLineToPoint:CGPointMake( i * _axisWidth1,_axisHeight-[_data[i] floatValue])];
    
        CGPoint point1=CGPointMake( i * _axisWidth1,_axisHeight-[_data[i] floatValue]);
        
        UIImageView *dianimageview=[[UIImageView alloc]initWithFrame:CGRectMake(point1.x-2, point1.y-2, 4, 4)];
        dianimageview.backgroundColor=[UIColor whiteColor];
        dianimageview.layer.cornerRadius=2;
        dianimageview.layer.masksToBounds=YES;
        
        [self addSubview:dianimageview];
        
    }

    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = self.bounds;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [[UIColor whiteColor] CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 0.5;
    pathLayer.lineJoin = kCALineJoinRound;   //线条
    
    [self.layer addSublayer:pathLayer];

}



@end
