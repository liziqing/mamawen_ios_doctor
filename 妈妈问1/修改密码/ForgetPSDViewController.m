//
//  ForgetPSDViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ForgetPSDViewController.h"
#import "BackView.h"
#import "AFNetworking.h"
#import "PonePSD.h"

@interface ForgetPSDViewController ()

@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
@property(strong,nonatomic)PonePSD *ponepsdVC;

@end

@implementation ForgetPSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
    [self editingText];

}

#pragma mark --杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
    [self.view sendSubviewToBack:backview];
    
    self.yanz.layer.cornerRadius=kBtnCornerRadius;
    self.yanz.layer.masksToBounds=YES;
    
    self.nextBtn.layer.cornerRadius = kBtnCornerRadius;
    self.nextBtn.layer.masksToBounds = YES;
    
    self.poneimage.layer.cornerRadius = kBtnCornerRadius;
    self.poneimage.layer.masksToBounds=YES;
    
    self.yanzimage.layer.cornerRadius = kBtnCornerRadius;
    self.yanzimage.layer.masksToBounds=YES;
    
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    self.ponepsdVC = [[PonePSD alloc]init];
    
}

#pragma mark  文本
-(void)editingText{
    self.ponenumber.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.yanznumber.clearButtonMode=UITextFieldViewModeUnlessEditing;
}

#pragma mark 结束文本编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.ponenumber endEditing:YES];
    [self.yanznumber endEditing:YES];
}

#pragma mark --- 网络
-(void)networking{
    NSString *telepone=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/register/validate/%@",self.ponenumber.text];
    
    [_manager GET:telepone parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"--self.sendVerification--%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@", error);
    }];
}

#pragma mark 检验验证码
-(void)jianyanYZM{
    
    NSDictionary *dict = @{@"phoneNumber": self.ponenumber.text, @"code" : self.yanznumber.text};
    
    [_manager POST:@"http://115.159.49.31:9000/doctor/register/validate/code" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"self.testVerification--%@",responseObject);
        
        
//        [self.navigationController pushViewController:self.ponepsdVC animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark --返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag == 1){
        if(self.ponenumber.text.length == 0){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        }else
            [self networking];
        
    }else if(sender.tag == 2){
        if(self.ponenumber.text.length == 0 || self.yanznumber.text.length == 0){
             [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号或验证码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        }else{
          //  [self jianyanYZM];
            self.ponepsdVC.poneNum = self.ponenumber.text;
            [self.navigationController pushViewController:self.ponepsdVC animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
