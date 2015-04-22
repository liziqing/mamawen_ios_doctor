//
//  PonePSD.m
//  妈妈问1
//
//  Created by alex on 15/4/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "PonePSD.h"
#import "BackView.h"
#import "Constant.h"
#import "AFNetworking.h"

@interface PonePSD ()

@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;

@end

@implementation PonePSD

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
    [self editingText];
}

#pragma mark ----杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
    [self.view sendSubviewToBack:backview];
    
    self.newpsd.layer.cornerRadius = kBtnCornerRadius;
    self.newpsd.layer.masksToBounds = YES;
    
    self.newpsd2.layer.cornerRadius = kBtnCornerRadius;
    self.newpsd2.layer.masksToBounds = YES;
    
    self.finishBtn.layer.cornerRadius = kBtnCornerRadius;
    self.finishBtn.layer.masksToBounds=YES;
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer  =  [AFJSONRequestSerializer serializer];
}


#pragma mark  文本
-(void)editingText{
    self.newpsdText.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.newpadText2.clearButtonMode=UITextFieldViewModeUnlessEditing;
}

#pragma mark 结束文本编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.newpsdText endEditing:YES];
    [self.newpadText2 endEditing:YES];
}


#pragma mark  --网络
-(void)networking{
    NSString *urlPath = [kUrlPath stringByAppendingFormat:@"%@",@"/doctor/phone/password/reset"];
    NSDictionary *dict = @{@"phoneNumber":self.poneNum,@"newPassword":self.newpadText2.text};
    
    [self.manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"--%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---%@",error);
    }];
}




#pragma mark 返回等按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
