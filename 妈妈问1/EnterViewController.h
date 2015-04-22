//
//  EnterViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"
#import "AFNetworking.h"
#import "TabBarViewController.h"
#import "UserInfo.h"
#import "BackView.h"

@interface EnterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImage; //医生头像
@property (weak, nonatomic) IBOutlet UILabel *registerIcon;//注册图标
@property (weak, nonatomic) IBOutlet UILabel *forgetPsd; //忘记密码
@property (weak, nonatomic) IBOutlet UILabel *tiyanyixia;//体验一下

@property (weak, nonatomic) IBOutlet UITextField *poneNunberText;//用户名
@property (weak, nonatomic) IBOutlet UITextField *poneNunberPsd;//密码


@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@property (nonatomic, strong)  TabBarViewController *tabBarVier;
- (IBAction)enterAction:(UIButton *)sender;

//医生信息
@property(strong,nonatomic)UserInfo *user;


//+(EnterViewController *)EnterViewController;



@end
