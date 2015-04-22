//
//  AddNewPatientViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AddNewPatientViewController.h"
#import "BackView.h"

@interface AddNewPatientViewController ()

@end

@implementation AddNewPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backView=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backView];
    [self.view sendSubviewToBack:backView];
    
}

#pragma mark 返回按钮事件
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
