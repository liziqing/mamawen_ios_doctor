//
//  PatientListVC.m
//  妈妈问1
//
//  Created by alex on 15/4/10.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "PatientListVC.h"
#import "BackView.h"

@interface PatientListVC ()

@end

@implementation PatientListVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
    
     [self.view sendSubviewToBack:backview];
}

#pragma mark 返回按钮事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag== 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
