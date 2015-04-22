//
//  AddPatientViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddPatientViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImage;   // 医生头像
@property (weak, nonatomic) IBOutlet UIButton *phoneIcon;  //按钮属性

@property (weak, nonatomic) IBOutlet UIImageView *imageview;  //二维码

- (IBAction)backBtn:(UIButton *)sender;

@end
