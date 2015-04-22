//
//  EndPrediagnosisViewController.m
//  妈妈问1
//
//  Created by lixuan on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "EndPrediagnosisViewController.h"
#import "HHTextView.h"
#import "Constant.h"
@interface EndPrediagnosisViewController () <UITextViewDelegate>
{
    HHTextView *_textV1;
    HHTextView *_textV2;
  
}
@end

@implementation EndPrediagnosisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self uiConfig];
}
- (void)uiConfig {
//   CGFloat H = [[UIScreen mainScreen] bounds].size.height;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 40)];
    lable.text = @"预诊报告";
    lable.textAlignment = NSTextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:18];
    lable.textColor = [UIColor whiteColor];
    [self.view addSubview:lable];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lable.frame), kScreenWidth - 60, 1)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    UILabel *problemLable = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(lineView.frame) + 10, 120, 20)];
    problemLable.text = @"疑似问题:";
    problemLable.font = [UIFont systemFontOfSize:16];
    problemLable.textColor = [UIColor whiteColor];;
    [self.view addSubview:problemLable];
    
    
    UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(problemLable.frame) + 2, 16, 16)];
    v1.layer.cornerRadius = 8;
    v1.layer.masksToBounds = YES;
    v1.image = [UIImage imageNamed:@"17_03"];
    [self.view addSubview:v1];
    
    _textV1 = [[HHTextView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(problemLable.frame) + 10, self.view.frame.size.width - 50 * 2, kScreenHeight / 5)];
    _textV1.delegate = self;
    _textV1.placeHolder = @"  患者问题描述";
    _textV1.backgroundColor = [UIColor colorWithRed:0.74 green:0.85 blue:0.93 alpha:1];
    [self.view addSubview:_textV1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_textV1.frame) + 15, CGRectGetWidth(lineView.frame), 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView2];
    
    UILabel *suggestLable = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(lineView2.frame) + 15, CGRectGetWidth(problemLable.frame), CGRectGetHeight(problemLable.frame))];
    suggestLable.text = @"医生建议:";
    suggestLable.font = [UIFont systemFontOfSize:16];
    suggestLable.textColor = [UIColor whiteColor];
    [self.view addSubview:suggestLable];
    
    UIImageView *v2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(suggestLable.frame) + 2, 16, 16)];
    v2.layer.cornerRadius = 8;
    v2.layer.masksToBounds = YES;
    v2.image = [UIImage imageNamed:@"17_06"];
    [self.view addSubview:v2];
    
    
    _textV2 = [[HHTextView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(suggestLable.frame) + 10, _textV1.frame.size.width, kScreenHeight / 5)];
    _textV2.delegate = self;
    _textV2.placeHolder = @"  给患者的建议内容";
    _textV2.backgroundColor = [UIColor colorWithRed:0.74 green:0.85 blue:0.93 alpha:1];
    [self.view addSubview:_textV2];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(30, CGRectGetHeight(self.view.frame) - 80, kScreenWidth - 70, 50);
    [btn setTitle:@"发  送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:0.16 green:0.82 blue:0.88 alpha:1]];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:64];
    btn.layer.cornerRadius = 8;
    btn.layer.masksToBounds = YES;
    [self.view addSubview:btn];
}
- (void)btnClick {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_textV1.text forKey:@"problem"];
    [dic setObject:_textV2.text forKey:@"suggest"];
    _patientInfoCB(dic,_mesInfoDic);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backimage.jpg"]];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backimage.jpg"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 5, 32, 32);
    btn.layer.cornerRadius = 16;
    btn.layer.masksToBounds = YES;
    [btn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBarButtonItemClick) forControlEvents:64];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)backBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
