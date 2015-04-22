//
//  ChargeVC.m
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ChargeVC.h"
#import "AFNetworking.h"
#import "BackView.h"
#import "UserInfo.h"
#import "ChargeTableVcCell1.h"
#import "ChargeTableVcCell2.h"
#import "ChargeCell3.h"
#import "ChargeTableViewCell4.h"

@interface ChargeVC ()

{

}
@property(strong,nonatomic)UserInfo *doctor;
@property(strong,nonatomic)UITableView *chargeTableVC;
@property(strong,nonatomic)AFHTTPRequestOperationManager *mannager;

@end

@implementation ChargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark --杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.chargeTableVC=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70)];
    self.chargeTableVC.delegate=self;
    self.chargeTableVC.dataSource=self;
    self.chargeTableVC.backgroundColor=[UIColor clearColor];
    self.chargeTableVC.tableFooterView=[[UIView alloc]init];
    self.chargeTableVC.showsVerticalScrollIndicator=YES;
    self.chargeTableVC.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chargeTableVC];
    
//--------------------------------------网络
    _mannager=[AFHTTPRequestOperationManager manager];
    _mannager.requestSerializer=[AFJSONRequestSerializer serializer];
    _mannager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    
}

#pragma mark tableview datasource delegate
#pragma mark --块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
#pragma mark --行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 1 ){
        return 5;
    }else if(section == 2 ){
        return 1;
    }else if(section == 3 ){
        return 1;
    }else
        return 1;
    
}

#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *chargeInfo=@"chargeInfo";
    UITableViewCell *chargeTableVcCell=[tableView dequeueReusableCellWithIdentifier:chargeInfo];
    if(chargeTableVcCell == nil ){
        chargeTableVcCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chargeInfo];
    }
    if(indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 3 ){
        ChargeTableVcCell1 *chargeCell1=[ChargeTableVcCell1 ChargeTableVcCell1];
        NSArray *array1=@[@[@"新患者免费期限"],@[@""],@[@"每周义诊"],@[@"付费功能介绍"]];
        if(indexPath.section !=0){
            chargeCell1.cellLable.hidden=YES;
        }
        chargeCell1.titleLable1.text=array1[indexPath.section][indexPath.row];
        
        return chargeCell1;
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        ChargeTableVcCell2 *chargeCell2=[ChargeTableVcCell2 ChargeTableVcCell2];
        
        chargeCell2.selectionStyle=UITableViewCellSelectionStyleNone;
        return chargeCell2;
        
    }else if(indexPath.section == 1 && indexPath.row != 0){
        ChargeCell3 *chargeCell3=[ChargeCell3 ChargeCell3];
        NSArray *array3=@[@[@""],@[@"电话咨询",@"按此咨询",@"私人医生",@"门诊加号"]];
        chargeCell3.titleLable.text=array3[indexPath.section][indexPath.row-1];
        return chargeCell3;
        
    }else if(indexPath.section == 4 ){
        ChargeTableViewCell4 *chargeCell4=[ChargeTableViewCell4 ChargeTableViewCell4];
        return chargeCell4;
        
    }else{
        chargeTableVcCell.backgroundColor=[UIColor clearColor];
        return chargeTableVcCell;
    }
}
#pragma mark -- row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 4){
        return 120;
    }else
    return 40;
        
}

#pragma mark -section height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 || section == 1 ){
        return 30;
    }else
        return 10;
}

#pragma mark --section view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionview1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    sectionview1.backgroundColor=[UIColor clearColor];
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 5, kScreenWidth-30, 20)];
    titleLable.font=[UIFont systemFontOfSize:13.0f];
    titleLable.textColor=[UIColor whiteColor];
    [sectionview1 addSubview:titleLable];
    if(section == 0){
        titleLable.text=@"基础服务(免费期限内患者可向您发送消息)";
        
        return sectionview1;
        
    }else if(section == 1 ){
        titleLable.text=@"增值服务";
        return sectionview1;
    }else{
        UIView *sectionview2=[[UIView alloc]init];
        sectionview2.backgroundColor=[UIColor clearColor];
        return sectionview2;
    }
}

#pragma mark -- select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- 返回事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0 ){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag == 1){
        [self networkRequest];
    }
}


#pragma mark -- 网络请求事件
-(void)networkRequest{
    NSString *urlPath=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/servingfee/update?uid=%i&sessionkey=%i",[self.doctor.userID integerValue] ,123];
    
    NSDictionary *dict=@{@"freeServing":@"true",@"imgTxtDiagFee":@"21",@"phnDiagFee":@"21",@"prvtDiagFee":@"3",@"diagPlusFee":@"43",@"voltrWeekday":@"4",@"freeCount":@"2"};
    
    [_mannager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
        NSLog(@"成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}


#pragma mark  --视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    _doctor=[UserInfo sharedUserInfo];
    self.tabBarController.tabBar.hidden=YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
