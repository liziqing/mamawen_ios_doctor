//
//  EndPrediagnosisViewController.h
//  妈妈问1
//
//  Created by lixuan on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndPrediagnosisViewController : UIViewController
@property (nonatomic, copy) void(^patientInfoCB)(NSDictionary *infoDic,NSDictionary *mesInfo);
@property (nonatomic, strong) NSDictionary *mesInfoDic;
@end
