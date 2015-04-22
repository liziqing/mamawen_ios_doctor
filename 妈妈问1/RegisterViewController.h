//
//  RegisterViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackView.h"

@class BasicMessageViewController;

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *poneNumberText1;//手机号
@property (weak, nonatomic) IBOutlet UITextField *poneText2;//验证码
@property (weak, nonatomic) IBOutlet UIButton *poneAction2; //发送验证码按钮属性
@property (weak, nonatomic) IBOutlet UIButton *nextAction;  //下一步按钮属性
@property (weak, nonatomic) IBOutlet UITextField *ponepwd3;//密码


- (IBAction)NextButton:(UIButton *)sender;


@end
