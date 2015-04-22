//
//  TelephoneViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "TelephoneViewController.h"
#import "BackView.h"
#import "UserInfo.h"

//---------------he---------
#import "FriendsModel.h"
#import "FRDListDBManger.h"

//-----------------he--------------

@interface TelephoneViewController ()

@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation TelephoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    NSArray *numberArray=@[@[@"10_07",@"10_09",@"10_11"],@[@"10_16",@"10_17",@"10_18"],@[@"10_23",@"10_24",@"10_25"],@[@"10_29",@"10_30",@"10_31"]];
    for(NSInteger i=0;i<4;i++){
        for(NSInteger j=0;j<3;j++){
            UIButton *numberIcon=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            numberIcon.frame=CGRectMake(30+j*((kScreenWidth-40)/3), 130+i*(85), 70, 70);
            [numberIcon setBackgroundImage:[UIImage imageNamed:numberArray[i][j]] forState:UIControlStateNormal];
            
            numberIcon.tag=[[NSString stringWithFormat:@"%i%i",i,j]integerValue];
            [numberIcon addTarget:self action:@selector(numberAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:numberIcon];
        }
    }
}

#pragma mark 电话按钮事件
-(void)numberAction:(UIButton *)sender{
    if(sender.tag == 0){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-1"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"1"];
        
    }else if(sender.tag == 1){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-2"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"2"];
        
    }else if(sender.tag == 2){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-3"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"3"];
        
    }else if(sender.tag == 10){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-4"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"4"];
        
    }else if(sender.tag == 11){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-5"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"5"];
        
    }else if(sender.tag == 12){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-6"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"6"];
        
    }else if(sender.tag == 20){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-7"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"7"];
        
    }else if(sender.tag == 21){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-8"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"8"];
        
    }else if(sender.tag == 22){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-9"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"9"];
        
    }else if(sender.tag == 30){
       
    }else if(sender.tag == 31){
        if(self.telePhone.text.length==3 || self.telePhone.text.length ==8){
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"-0"];
        }else
            self.telePhone.text=[self.telePhone.text stringByAppendingString:@"0"];
        
    }else if(sender.tag == 32){
        if(self.telePhone.text.length >=11){
            NSString *telephoneString=[NSString stringWithFormat:@"%@%@%@",[self.telePhone.text substringWithRange:NSMakeRange(0, 3)],[self.telePhone.text substringWithRange:NSMakeRange(4, 4)],[self.telePhone.text substringWithRange:NSMakeRange(9, self.telePhone.text.length-9)]];
            NSLog(@"---%@",telephoneString);
   
//----------------------he----------------
            FriendsModel *fm = [[FriendsModel alloc] init];
            fm.name = telephoneString;
            fm.doctoerid = _doctor.userID;

            FRDListDBManger *dbm = [FRDListDBManger sharedManager];
            if (![dbm isExists:fm.phone]) {
                [dbm insertModel:fm];
                // 上传无服务i
            }
            
            
            
        }
    }
    self.jianBtn.hidden=NO;
}

#pragma mark 返回按钮事件
- (IBAction)backAction:(UIButton *)sender {
    if(sender.tag == 0 ){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == 1 ){
        self.telePhone.text=[self.telePhone.text substringWithRange:NSMakeRange(0, self.telePhone.text.length-1)];
        if(self.telePhone.text.length == 0){
            self.jianBtn.hidden=YES;
            
        }else{
            self.jianBtn.hidden=NO;
   
        }
    }
}

#pragma mark----- 
-(void)viewWillAppear:(BOOL)animated{
    self.jianBtn.hidden=YES;
    self.doctor=[UserInfo sharedUserInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
