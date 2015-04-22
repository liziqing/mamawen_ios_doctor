//
//  BindingAcountVC.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "BindingAcountVC.h"
#import "BackView.h"
#import "BDTableVCell.h"
#import "UserInfo.h"

@interface BindingAcountVC ()

@property(strong,nonatomic)UITableView *bindingAcountTableV;
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation BindingAcountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.doctor=[UserInfo sharedUserInfo];
    
    self.bindingAcountTableV=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.bindingAcountTableV.dataSource=self;
    self.bindingAcountTableV.delegate=self;
    self.bindingAcountTableV.showsVerticalScrollIndicator=YES;
    self.bindingAcountTableV.tableFooterView=[[UIView alloc]init];
    self.bindingAcountTableV.backgroundColor=[UIColor clearColor];
    self.bindingAcountTableV.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.bindingAcountTableV];
    
}

#pragma mark 块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark -- 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 ){
        return 1;
    }else if(section == 1 ){
        return 2;
    }else
        return 3;
}

#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BDTableVCell *bdtableviewCell=[BDTableVCell bdtablevCell];
    static NSString *bdTableVInfo=@"bdTableVInfo";
    
    UITableViewCell *bdTableVCell=[tableView dequeueReusableCellWithIdentifier:bdTableVInfo];
    if(bdTableVCell == nil ){
        bdTableVCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bdTableVInfo];
    }
    bdtableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2){
        NSArray *titleArray=@[@[@"医生号"],@[@"手机号",@"邮箱地址"],@[@"微信",@"QQ",@"新浪微博"]];
        bdtableviewCell.titleLable.text = titleArray[indexPath.section][indexPath.row];
        
        if(indexPath.section == 0 || (indexPath.section ==1 && indexPath.row ==1) || (indexPath.section==2 && indexPath.row == 2) ){
            bdtableviewCell.linev.hidden=YES;
     
        }
        if(indexPath.section == 0 && indexPath.row == 0 ){
                bdtableviewCell.contentLable.text=[NSString stringWithFormat:@"%@",self.doctor.userID];
            
        }else if(indexPath.section == 1 && indexPath.row== 0){
            bdtableviewCell.contentLable.text=self.doctor.userTelephone;
            
        }else if(indexPath.section == 1 && indexPath.row == 1){
            bdtableviewCell.contentLable.text=@"";
        }else
            bdtableviewCell.contentLable.text=@"1";
        
        if(indexPath.section != 2){
            bdtableviewCell.BDimage.hidden=YES;
            bdtableviewCell.contentLable.hidden=NO;
        }else{
            bdtableviewCell.BDimage.hidden=NO;
            bdtableviewCell.contentLable.hidden=YES;
        }
        return bdtableviewCell;
        
    }else{
        bdtableviewCell.contentLable.text=@"2";
        bdTableVCell.backgroundColor=[UIColor clearColor];
        return bdTableVCell;
    }
}

#pragma mark section height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==1 || section == 2){
        return 10;
    }else
        return 0;
}

#pragma mark --sectionview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headview.backgroundColor=[UIColor clearColor];
    return headview;
}

#pragma mark - 返回事件
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
