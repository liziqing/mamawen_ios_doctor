//
//  EndPrediagnosisView.h
//  妈妈问1
//
//  Created by lixuan on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//



// 医生端结束问诊显示view
#import <UIKit/UIKit.h>

@interface EndPrediagnosisView : UIView
@property (nonatomic,copy) NSString *problem;
@property (nonatomic,copy) NSString *suggest;

@property (nonatomic, copy) void(^getScore)();
@end
