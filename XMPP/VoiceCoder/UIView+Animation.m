//
//  UIView+Animation.m
//  RecorderTranscodeDemo
//
//  Created by lixuan on 15/2/6.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "UIView+Animation.h"
#import "AppDelegate.h"


#define kScaleMin             0.007f
#define kScaleDefault         1.0f
#define kScaleDelta           0.05f


#define kFirstAnimateTime     0.3f
#define kSecondAnimateTime    0.2f

#define kMaskViewFinalAlpha   0.2f

@interface ViewInfo : NSObject

@property (strong, nonatomic) UIView      *displayView;   //显示页面
@property (assign, nonatomic) AnimateType aType;          //动画类型
@property (assign, nonatomic) CGRect      displayRect;    //显示的位置
@property (strong, nonatomic) UIControl   *maskView;      //遮挡页面
@property (copy, nonatomic)   void        (^showBlock)(BOOL finished);
@property (copy, nonatomic)   void        (^hideBlock)(BOOL finished);
@end

@implementation ViewInfo

@end


@implementation UIView (Animation)

static NSMutableArray   *displayViewAry;//已显示的页面数组


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
#pragma mark - 获取顶部View
+ (AppDelegate *)getAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+ (UIView *)getTopView{
//    return [[[UIView getAppDelegate] viewController] view];
    
    return [[self getCurrentVC] view];
}
///Users/lixuan/Desktop/百卡会Demo/RecorderTranscodeDemo/RecorderTranscodeDemo/UIView+Animation.m:47:13: Receiver type 'MainViewController' for instance message is a forward declaration
#pragma mark - 顶层maskView触摸
+ (void)setTopMaskViewCanTouch:(BOOL)canTouch{
    ViewInfo *info = [displayViewAry lastObject];
    if (canTouch)
        [info.maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    else
        [info.maskView removeTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - 下面的增加了完成块
/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 @param completion 动画块
 */
+ (void)showView:(UIView*)view animateType:(AnimateType)aType finalRect:(CGRect)fRect completion:(void(^)(BOOL finished))completion{
    //初始化页面数组
    if (displayViewAry == nil)
        displayViewAry = [[NSMutableArray alloc]init];
    
    UIView *topView = [UIView getTopView];
    
    //存储页面信息
    ViewInfo *info = [[ViewInfo alloc]init];
    info.displayView = view;
    info.aType = aType;
    info.displayRect = fRect;
    
    //初始化遮罩页面
    UIControl *maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0;
    maskView.frame = topView.bounds;
    [maskView addTarget:self action:@selector(maskViewTouch) forControlEvents:UIControlEventTouchUpInside];
    //添加页面
    [topView addSubview:maskView];
    [topView bringSubviewToFront:maskView];
    
    info.maskView = maskView;
    
    if (completion)
        info.showBlock = completion;
    
    [displayViewAry addObject:info];
    
    
    //根据不同的动画类型显示
    switch (aType) {
        case AnimateTypeOfTV:
            [UIView showTV];
            break;
        case AnimateTypeOfPopping:
            [UIView showPopping];
        default:
            break;
    }
}
/**
 显示view
 @param _view 需要显示的view
 @param _aType 动画类型
 @param _fRect 最终位置
 */
+ (void)showView:(UIView*)view animateType:(AnimateType)aType finalRect:(CGRect)fRect{
    [self showView:view animateType:aType finalRect:fRect completion:nil];
}


#pragma mark - 消失view

+ (void)hideViewByCompletion:(void(^)(BOOL finished))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}
+ (void)hideViewByType:(AnimateType)aType completion:(void(^)(BOOL))completion{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        info.aType = aType;
        if (completion)
            info.hideBlock = completion;
    }
    [UIView maskViewTouch];
}

+ (void)hideView{
    [UIView hideViewByCompletion:nil];
}
+ (void)hideViewByType:(AnimateType)aType{
    [UIView hideViewByType:aType completion:nil];
}

#pragma mark - 触摸背景
+ (void)maskViewTouch{
    if ([displayViewAry count] > 0){
        ViewInfo *info = [displayViewAry lastObject];
        
        //根据不同类型隐藏
        switch (info.aType) {
            case AnimateTypeOfTV:
                [UIView hideTV];
                break;
            case AnimateTypeOfPopping:
                [UIView hidePopping];
                break;
            default:
                break;
        }
    }
}
#pragma mark - 移除遮罩和已显示页面
+ (void)removeMaskViewAndDisplay:(ViewInfo*)info{
    if (info.aType == AnimateTypeOfTV || info.aType == AnimateTypeOfPopping)  //TV,Popping 类型需要还原
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
    
    [info.displayView removeFromSuperview];
    [info.maskView removeFromSuperview];
    [displayViewAry removeObject:info];
}

#pragma mark - 显示动画

#pragma mark - TV 显示
+ (void)showTV{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.maskView.alpha = 0.1f;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.maskView.alpha = kMaskViewFinalAlpha;
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.showBlock)
                info.showBlock(finish);
        }];
    }];
}
#pragma mark - TV 消失
+ (void)hideTV{
    
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kSecondAnimateTime animations:^{
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleMin);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kFirstAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
            info.maskView.alpha = 0;
        }completion:^(BOOL finish){
            //调用完成动画块
            if (info.hideBlock)
                info.hideBlock(finish);
            [UIView removeMaskViewAndDisplay:info];
        }];
    }];
}

#pragma mark - Popping 显示
+ (void)showPopping{
    ViewInfo *info = [displayViewAry lastObject];
    UIView *topView = [UIView getTopView];
    info.displayView.frame = info.displayRect;
    [topView addSubview:info.displayView];
    [topView bringSubviewToFront:info.displayView];
    
    info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    
    //开始动画
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = kMaskViewFinalAlpha;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault+kScaleDelta, kScaleDefault+kScaleDelta);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:kSecondAnimateTime animations:^{
            info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault-kScaleDelta, kScaleDefault-kScaleDelta);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:kSecondAnimateTime animations:^{
                info.displayView.transform = CGAffineTransformMakeScale(kScaleDefault, kScaleDefault);
            }completion:^(BOOL finish){
                //调用完成动画块
                if (info.showBlock)
                    info.showBlock(finish);
            }];
        }];
    }];
}
#pragma mark - Popping 消失
+ (void)hidePopping{
    ViewInfo *info = [displayViewAry lastObject];
    
    [UIView animateWithDuration:kFirstAnimateTime animations:^{
        info.maskView.alpha = 0;
        info.displayView.transform = CGAffineTransformMakeScale(kScaleMin, kScaleMin);
    }completion:^(BOOL finish){
        //调用完成动画块
        if (info.hideBlock)
            info.hideBlock(finish);
        [UIView removeMaskViewAndDisplay:info];
    }];
}
@end
