//
//  RevampPsdVC.m
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RevampPsdVC.h"
#import "BackView.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "NSString+psd.h"

@interface RevampPsdVC ()
{
    
}

@property(strong,nonatomic)UserInfo *doctor;
@end

@implementation RevampPsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
    [self textRedact];
}

#pragma mark -杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.finishBtn.layer.cornerRadius=3;
    self.finishBtn.layer.masksToBounds=YES;
    
  
    
    self.doctor=[UserInfo sharedUserInfo];

}

#pragma mark -文本编辑
-(void)textRedact{
//------------------------------------------安全属性
    self.originalText.secureTextEntry=YES;
    self.psdNew1.secureTextEntry=YES;
    self.psdNew2.secureTextEntry=YES;
    
//-----------------------------------------删除模式
    self.originalText.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.psdNew1.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.psdNew2.clearButtonMode=UITextFieldViewModeUnlessEditing;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.originalText endEditing:YES];
    [self.psdNew1 endEditing:YES];
    [self.psdNew2 endEditing:YES];
}
#pragma mark -返回,完成事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag == 1){
        if(self.originalText.text.length == 0){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"你输入的密码为空,请输入原密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
            
        }else if(self.psdNew1.text.length == 0 || self.psdNew2.text.length == 0){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"你输入的密码为空,请输入新密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
            
        }else if(![self.psdNew1.text isEqualToString:self.psdNew2.text]){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"你输入的密码不一致,请从新输入" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
            
        }else{
            [self networking];
        }
        
    }
    
}

#pragma mark -网络请求修改密码
-(void)networking{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"id":self.doctor.userID, @"oldPassword" :[[self.originalText.text sha256Encrypt]base64Encrypt],@"newPassword":[[self.psdNew1.text sha256Encrypt]base64Encrypt]};
    NSString *urlPsd=[NSString stringWithFormat:@"http:115.159.49.31:9000/doctor/password/reset?uid=%@&sessionkey=%@",self.doctor.userID,@"123"];
    
    [manager POST:urlPsd parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if([[dic objectForKey:@"code"] integerValue]==0){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查你的网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
