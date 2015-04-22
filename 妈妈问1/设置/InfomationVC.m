//
//  InfomationVC.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "InfomationVC.h"
#import "BackView.h"
#import "InformationCell.h"

@interface InfomationVC ()
{
    UISwitch *switch1;
    UISwitch *switch2;
    UISwitch *switch3;
    UISwitch *switch4;
}

@property(strong,nonatomic)UITableView *informationTableVC;
@end

@implementation InfomationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];

//----------------------------开关按钮
    switch1=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-79, 5, 49, 31)];
    switch1.tag=1;
    [switch1 addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    switch2=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-79, 5, 49, 31)];
    switch2.tag=2;
    [switch2 addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    switch3=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-79, 5, 49, 31)];
    switch3.tag=3;
    [switch3 addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    switch4=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-79, 5, 49, 31)];
    switch4.tag=1;
    [switch4 addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.informationTableVC=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70)];
    self.informationTableVC.dataSource=self;
    self.informationTableVC.delegate=self;
    self.informationTableVC.tableFooterView=[[UIView alloc]init];
    self.informationTableVC.backgroundColor=[UIColor clearColor];
    self.informationTableVC.showsVerticalScrollIndicator=YES;
    self.informationTableVC.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.informationTableVC];
    
}

#pragma mark --开关事件
-(void)switchBtn:(UISwitch *)sender{
    if(sender.tag == 0){
        
    }
}





#pragma mark 块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

#pragma mark --行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2 ){
        return 2;
    }else
        return 0;
}

#pragma mark -cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *titleArray=@[@[@"新消息通知"],@[@"通知显示消息详情"],@[@"声音",@"震动"],@[@""]];
    static NSString *informationInfo=@"informationInfo";
    InformationCell *informationCell=[tableView dequeueReusableCellWithIdentifier:informationInfo];
    if(informationCell == nil){
        informationCell = [InformationCell InformationCell];
    }
    if(indexPath.section ==2 && indexPath.row == 0){
        informationCell.line.hidden=NO;
    }else
        informationCell.line.hidden=YES;
    
    if(indexPath.section == 0){
        [informationCell.contentView addSubview:switch1];
        
    }else if(indexPath.section == 1){
        [informationCell.contentView addSubview:switch2];
        
    }else if(indexPath.section == 2 && indexPath.row == 0){
        [informationCell.contentView addSubview:switch3];
        
    }else{
        [informationCell.contentView addSubview:switch4];
        
    }
    informationCell.titleLable.text=titleArray[indexPath.section][indexPath.row];
    return informationCell;
    
}

#pragma mark -row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

#pragma mark -- section height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1 || section == 2 || section ==3 ){
        return 50;
    }else
        return 0;
}

#pragma mark --sectionview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    headview.backgroundColor=[UIColor clearColor];
    UILabel *tishiLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 0, kScreenWidth-60, 50)];
    tishiLable.font=[UIFont systemFontOfSize:13.0f];
    tishiLable.textColor=[UIColor whiteColor];
    [headview addSubview:tishiLable];
    
    if(section == 1){
        tishiLable.text=@"如果你要关闭或开启应用的新消息通知,请在iPhone的“设置”-“通知”功能中，找到应用程序“妈妈问-医生版”更改";
        tishiLable.numberOfLines=0;
        CGSize size=CGSizeMake(kScreenWidth-60, 50);
        CGSize size1=[tishiLable sizeThatFits:size];
        tishiLable.frame=CGRectMake(30, 0,size1.width, size1.height);
    }else if(section == 2){
        tishiLable.text=@"若关闭,当收到应用消息时,通知提示将不显示发信人和内容摘要";
        tishiLable.numberOfLines=0;
        CGSize size=CGSizeMake(kScreenWidth-60, 50);
        CGSize size1=[tishiLable sizeThatFits:size];
        tishiLable.frame=CGRectMake(30, 0,size1.width, size1.height);
    }else{
        tishiLable.text=@"当应用在运行时,你可以设置是否需要声音或震动";
        tishiLable.numberOfLines=0;
        CGSize size=CGSizeMake(kScreenWidth-60, 50);
        CGSize size1=[tishiLable sizeThatFits:size];
        tishiLable.frame=CGRectMake(30, 0,size1.width, size1.height);
    }
    
    return headview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -返回事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
