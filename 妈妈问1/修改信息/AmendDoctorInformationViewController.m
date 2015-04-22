//
//  AmendDoctorInformationViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AmendDoctorInformationViewController.h"
#import "BackView.h"
#import "UserInfo.h"
#import "AFNetworking.h"

@interface AmendDoctorInformationViewController ()
{
    
}
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation AmendDoctorInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

-(void)viewWillAppear:(BOOL)animated{
    self.doctor=[UserInfo sharedUserInfo];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    
    
    if(self.cellInfo == 1){
        self.amendTitleLable.text=@"昵称修改";
        
    }else if (self.cellInfo == 3){
        self.amendTitleLable.text=@"收货修改";
        
    }else if(self.cellInfo == 20){
        self.amendTitleLable.text= @"擅长";
        
    }else if(self.cellInfo == 21){
        self.amendTitleLable.text= @"背景";
        
    }else
        self.amendTitleLable.text= @"成就";
    self.amendInformation.text=self.textStr;
}






#pragma mark 取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.amendInformation endEditing:YES];
}

#pragma mark 返回按钮事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        if(self.cellInfo == 1 ){
            
            if(self.cellInfo == 1){
                if(self.amendInformation.text.length != 0){
                    self.doctor.userName=self.amendInformation.text;
                }
            }
            [self network1];
            
        }else if(self.cellInfo == 3){
            if(self.amendInformation.text.length != 0){
                self.doctor.doctorShouhuoAddress=self.amendInformation.text;
            }
            
        }else if(self.cellInfo == 20 || self.cellInfo == 21 || self.cellInfo == 22){
            if(self.cellInfo == 20){
                if(self.amendInformation.text.length != 0){
                    self.doctor.userAdept=self.amendInformation.text;
                }
            
            }else if(self.cellInfo == 21){
                if(self.amendInformation.text.length != 0){
                    self.doctor.userBackgrop=self.amendInformation.text;
                }
                
            }else if(self.cellInfo == 22){
                if(self.amendInformation.text.length != 0){
                    self.doctor.userAchievement=self.amendInformation.text;
                }
            }
            [self network3];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)network1{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"name":self.doctor.userName, @"hospital" :self.doctor.userHospital,@"department":self.doctor.userOffice,@"title":self.doctor.userZhichen};
    NSString *urlPath=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/information/update?uid=%@&sessionkey=%@",self.doctor.userID,self.doctor.sessionKey];
    [manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
        NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}



#pragma mark   网络请求
-(void)network3{
    //-----------------------------网络请求
    AFHTTPRequestOperationManager *manager1=[AFHTTPRequestOperationManager manager];
    manager1.responseSerializer=[AFJSONResponseSerializer serializer];
    manager1.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *dict1=@{@"goodAt":self.doctor.userAdept,@"background":self.doctor.userBackgrop,@"achievement":self.doctor.userAchievement,@"serveMore":@(YES)};
    NSString *urlPath1=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/extra/information/update?uid=%@&sessionkey=%@",self.doctor.userID,self.doctor.sessionKey];
    [manager1 POST:urlPath1 parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
