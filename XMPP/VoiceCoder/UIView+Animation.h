//
//  UIView+Animation.h
//  RecorderTranscodeDemo
//
//  Created by lixuan on 15/2/6.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultAnimateTime 0.25f

typedef enum AnimateType{  // 动画类型
    AnimateTypeOfTV,       // 电视
    AnimateTypeOfPopping,  // 弹性缩小放大
    AnimateTypeOfLeft,     // 左
    AnimateTypeOfRight,    // 右
    AnimateTypeOfTop,      // 上
    AnimateTypeOfBottom    // 下
}AnimateType;



@interface UIView (Animation)

// 获取顶部View
+(UIView *)getTopView;


// 顶层maskView触摸
+(void)setTopMaskViewCanTouch:(BOOL)canTouch;

/*
  显示view
 @param view   需要显示的view
 @param aType  动画类型
 @param fRect  最终位置
 */
+(void)showView:(UIView *)view animateType:(AnimateType)aType finalRect:(CGRect)fRect;

// 隐藏view
+(void)hideView;

// 隐藏VIew
// @param aType 动画类型
+(void)hideViewByType:(AnimateType)aType;


//  
// 增加了完成回调块
+(void)showView:(UIView *)view animateType:(AnimateType)aType finalRect:(CGRect)fRect completion:(void(^)(BOOL finished))completion;
+(void)hideViewByCompletion:(void(^)(BOOL finished))completion;
+(void)hideViewByType:(AnimateType)aType completion:(void (^)(BOOL finished))completion;
@end
