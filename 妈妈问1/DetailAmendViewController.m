//
//  DetailAmendViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/7.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DetailAmendViewController.h"
#import "DateData.h"

@interface DetailAmendViewController ()



@property(strong,nonatomic)DateData *dateRemind;

@end

@implementation DetailAmendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self headView];
}

#pragma mark HeadView
-(void)headView{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    [self.view addSubview:self.detaiAmend];
    

}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.detaiAmend resignFirstResponder];
}

#pragma mark 返回按钮
- (IBAction)backAction:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        if([self.titleStr isEqualToString:@"标题修改"]){
            self.dateRemind.titleString=self.detaiAmend.text;
            
        }else if([self.titleStr isEqualToString:@"患者修改"]){
            self.dateRemind.patientString=self.detaiAmend.text;
        }else if([self.titleStr isEqualToString:@"内容修改"]){
            self.dateRemind.contentString=self.detaiAmend.text;
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.titleLable.text=self.titleStr;
    self.dateRemind=[DateData shareDateData];
    
    
    if([self.titleStr isEqualToString:@"标题修改"]){
        self.detaiAmend.text=self.dateRemind.titleString;
        
    }else if([self.titleStr isEqualToString:@"患者修改"]){
        self.detaiAmend.text=self.dateRemind.patientString;
        
    }else if([self.titleStr isEqualToString:@"内容修改"])
       self.detaiAmend.text=self.dateRemind.contentString;
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
