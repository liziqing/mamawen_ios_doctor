//
//  RegisterViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RegisterViewController.h"
#import "BasicMessageViewController.h"
#import "AFNetworking.h"

@interface RegisterViewController ()

@property(strong,nonatomic)NSDictionary *testVerification;
@property(strong,nonatomic)NSDictionary *sendVerification;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataProcessing];
    [self editText];
    [self backIcon];
    
}


#pragma mark --杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    //图标样式
    self.poneAction2.layer.cornerRadius=5;
    self.poneAction2.layer.masksToBounds=YES;
    
    self.nextAction.layer.cornerRadius=5;
    self.nextAction.layer.masksToBounds=YES;

}

#pragma mark -编辑文本
-(void)editText
{
    self.poneNumberText1.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.poneText2.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.ponepwd3.clearButtonMode=UITextFieldViewModeWhileEditing;
    self.ponepwd3.secureTextEntry=YES;
}

#pragma mark    -结束文本编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.poneNumberText1 endEditing:YES];
    [self.poneText2 endEditing:YES];
    [self.ponepwd3 endEditing:YES];
}

#pragma mark -下一步及其验证码按钮事件
- (IBAction)NextButton:(UIButton *)sender
{
    if (sender.tag==0) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag==1){
       
        [self huoquYZM];
        
    }else{
        [self jianyanYZM];
        if(self.poneNumberText1.text.length==0  ){
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.poneText2.text.length == 0){
             [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入验证码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.ponepwd3.text.length == 0){
              [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else{
            /*if([[self.testVerification objectForKey:@"message"]isEqualToString:@"success"]){*/
                BasicMessageViewController *basicMessageView=[[BasicMessageViewController alloc]init];
                basicMessageView.doctorChenni=self.poneNumberText1.text;
                basicMessageView.doctorPsd=self.ponepwd3.text;
                [self.navigationController pushViewController:basicMessageView animated:YES];
            /*}else{
                [[[UIAlertView alloc]initWithTitle:@"提示消息" message:@"您输入的验证码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
            }*/
        }
    }
}

#pragma mark 返回按钮样式
-(void)backIcon
{
    UIBarButtonItem *Backbutton=[[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem=Backbutton;
    self.title=@"";
}



#pragma mark 获取验证码
-(void)huoquYZM{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
 
    NSString *telepone=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/register/validate/%@",self.poneNumberText1.text];
    [manager GET:telepone parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.sendVerification=(NSDictionary *)responseObject;
        NSLog(@"--self.sendVerification--%@",self.sendVerification);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error--%@", error);
    }];
    
}

#pragma mark 检验验证码
-(void)jianyanYZM{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"phoneNumber": self.poneNumberText1.text, @"code" : self.poneText2.text};
    
    [manager POST:@"http://115.159.49.31:9000/doctor/register/validate/code" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.testVerification=(NSDictionary *)responseObject;
        NSLog(@"self.testVerification--%@",self.testVerification);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
