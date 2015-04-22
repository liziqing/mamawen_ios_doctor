//
//  UserInformationViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "UserInformationViewController.h"
#import "UpLoadPhoteViewController.h"
#import "SettingViewController.h"
#import "AcountBlanceVC.h"
#import "ChargeVC.h"
#import "doctorInformationCell3.h"

#import "AFNetworking.h"

@interface UserInformationViewController ()
{
    UIBarButtonItem *backbtn; //返回按钮
    UserInfo *doctorUser;
    NSArray *cellTitleNameArray; //cell的名字
    
//----余额与金币
    UIImageView *backimageview;
    UIView *moneyView;    //金额视图
    UIView *integralView; //积分视图
    UIView *lineView;
    
//---------------获取头像图片---------
    UIImage *doctorimage;

}
//----医生信息
@property(strong,nonatomic)UILabel *doctorNameLable;  //医生名字
@property(strong,nonatomic)UILabel *doctorInfoLable;  // 注册与否标识
@property(strong,nonatomic)UIImageView *doctorInfoImage;
@property(strong,nonatomic)UIView *line;
@property(strong,nonatomic)UILabel *doctorNumberLable;

@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;


@end

@implementation UserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataprocressing];
    [self changeNavigationBar];//navigationBar方法
    
        [self moneyAndIntegral];
//--------------手势方法调用
    [self addGR:moneyView];
    [self addGR:integralView];
}

#pragma mark 杂乱数据
-(void)dataprocressing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];

     doctorUser=[UserInfo sharedUserInfo];

    self.doctorInformationTableView.backgroundColor=[UIColor clearColor];
    self.doctorInformationTableView.tableFooterView=[[UIView alloc]init];
    self.doctorInformationTableView.delegate=self;
    self.doctorInformationTableView.dataSource=self;
    self.doctorInformationTableView.separatorStyle=UITableViewCellAccessoryNone;
    [self.view addSubview:self.doctorInformationTableView];
    
    //数据
    cellTitleNameArray=@[@"申请认证",@"定制服务",@"全部订单",@"赚取金币",@"设置与帮助"];
    
}
#pragma mark changeNavigationBar
-(void)changeNavigationBar
{
    
//headview
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(60, 50, 120, 30)];
    title.text=@"个人中心";
    title.textColor=[UIColor whiteColor];
    title.center=CGPointMake(kScreenWidth/2, 45);
    title.font=[UIFont systemFontOfSize:20.0f];
    title.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:title];
    
    //按钮
    UIButton *registerIcon=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerIcon.frame=CGRectMake(kNavigationBarWidth-60,20, 60, 40);
    registerIcon.tag=0;
    [registerIcon addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerIcon];
    
 
    backbtn=[[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem=backbtn;
    backbtn.title=@"个人信息";

}

#pragma mark actionIcon事件
-(void)actionIcon:(UIButton *)sender{

}

#pragma mark tableView的代理方法
#pragma mark 块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else
        return 5;
}

#pragma mark cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *userInformationTableViewInfo=@"doctorInformationTableViewInfo";
    UITableViewCell *userInformationTableViewCell=[tableView dequeueReusableCellWithIdentifier:userInformationTableViewInfo];
    if(userInformationTableViewCell==nil){
        userInformationTableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userInformationTableViewInfo];
    }
    if(indexPath.section==0 && indexPath.row==0){
        
        UserInformationTableViewCell *userInformationTableViewCell1=[UserInformationTableViewCell UserInformationTableViewCell];
 
        if (doctorimage)
            userInformationTableViewCell1.doctorHeadImage.image=doctorimage;
        
        
        [self addDoctorIformation];
        [userInformationTableViewCell1.contentView addSubview:self.doctorNameLable];
        [userInformationTableViewCell1.contentView addSubview:self.doctorInfoImage];
        [userInformationTableViewCell1.contentView addSubview:self.doctorInfoLable];
        [userInformationTableViewCell1.contentView addSubview:self.line];
        [userInformationTableViewCell1.contentView addSubview:self.doctorNumberLable];
        
        userInformationTableViewCell1.backgroundColor=[UIColor clearColor];
        return userInformationTableViewCell1;
        
    }else if(indexPath.section==0 && indexPath.row == 1){
        
        DoctorIntegralTableViewCell *doctorIntegralTableViewCell=[DoctorIntegralTableViewCell DoctorIntegralTableViewCell];
        
        [doctorIntegralTableViewCell.contentView addSubview:backimageview];
        [doctorIntegralTableViewCell.contentView addSubview:moneyView];
        [doctorIntegralTableViewCell.contentView addSubview:lineView];
        [doctorIntegralTableViewCell.contentView addSubview:integralView];
        return doctorIntegralTableViewCell;
        
    }else if(indexPath.section == 1){
        doctorInformationCell3 *mycell3=[doctorInformationCell3 doctorInformationCell3];
        NSArray *imageArray=@[@"0408_03",@"0408_06",@"0408_08",@"0408_10",@"0408_12"];
        mycell3.contentImage.image=[UIImage imageNamed:imageArray[indexPath.row]];
        mycell3.contentLable.text=cellTitleNameArray[indexPath.row];
        if(indexPath.row == 4){
            mycell3.line.hidden=YES;
        }
        return mycell3;
        
    }else{
    
        userInformationTableViewCell.backgroundColor=[UIColor clearColor];
        return userInformationTableViewCell;
    }
}

#pragma mark --section height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return 10;
    }else
        return 0;
}

#pragma mark -section view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]init];
    headview.backgroundColor=[UIColor clearColor];
    return headview;
}



#pragma mark row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row == 0){
        return 70;
    }else if(indexPath.section==0 && indexPath.row==1){
        return (kScreenHeight-60-10-44-70)/9;
    }else
        return (kScreenHeight-60-10-44-70)/9;
}
#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        DoctorInformationViewController *doctorInformationView=[[DoctorInformationViewController alloc]init];
        doctorInformationView.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:doctorInformationView animated:YES];
        
    }else if(indexPath.section==1 && indexPath.row == 0){
        UpLoadPhoteViewController *upLoadLisence=[[UpLoadPhoteViewController alloc]init];
        [self.navigationController pushViewController:upLoadLisence animated:YES];
        
        
    }else if (indexPath.section==1 && indexPath.row == 1){
        ChargeVC *chagevc = [[ChargeVC alloc]init];
        [self.navigationController pushViewController:chagevc animated:YES];
        
        
    }else if(indexPath.section==1 && indexPath.row == 2){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"敬请期待" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        
    }else if(indexPath.section==1 &&indexPath.row==3){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"敬请期待" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        
    }else if(indexPath.section==1 && indexPath.row== 4){
        SettingViewController *setingVC=[[SettingViewController alloc]init];
        [self.navigationController pushViewController:setingVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选定
}

#pragma mark 显示隐藏的tabbarview
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
}

#pragma mark 给医生数据 
-(void)addDoctorIformation{
//-----------------------------------医生昵称------------
    self.doctorNameLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 15, 40, 20)];
    
    self.doctorNameLable.text=doctorUser.userName;
    self.doctorNameLable.textColor=[UIColor whiteColor];
    self.doctorNameLable.font=[UIFont systemFontOfSize:18.0f];
    self.doctorNameLable.numberOfLines=1;
    CGSize size1 = CGSizeMake(80, 20);
    CGSize lablesize1 = [self.doctorNameLable sizeThatFits:size1];
    self.doctorNameLable.frame = CGRectMake(80,15, lablesize1.width, lablesize1.height);

//--------------------------------------标识图片-------------
    self.doctorInfoImage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.doctorNameLable.frame)+10, 15, 20, 20)];
    _doctorInfoImage.image=[UIImage imageNamed:@"11_07"];
  
//--------------------------------------标识书签------------
    self.doctorInfoLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_doctorInfoImage.frame), 15, 60, 21)];
    if([doctorUser.userlevel intValue]==0){
        self.doctorInfoLable.text=@"未认证医师";
    }else{
        self.doctorInfoLable.text=@"认证医师";
    }
    self.doctorInfoLable.font=[UIFont systemFontOfSize:12.0f];
    self.doctorInfoLable.textColor=[UIColor whiteColor];
    
    _line=[[UIView alloc]initWithFrame:CGRectMake(80, 35, 150, 1)];
    _line.backgroundColor=[UIColor whiteColor];

//--------------------------------------医生ID------------
    self.doctorNumberLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 37, 100, 20)];
    self.doctorNumberLable.textColor=[UIColor whiteColor];
    self.doctorNumberLable.text=[NSString stringWithFormat:@"医生号:%@",doctorUser.userID];
    self.doctorNumberLable.font=[UIFont systemFontOfSize:12.0f];
    
}

#pragma mark --金额与积分View
-(void)moneyAndIntegral{
    backimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backimageview.backgroundColor=[UIColor whiteColor];
    backimageview.alpha=0.1;
    
    moneyView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, (kScreenWidth-1)/2, 44)];
    moneyView.tag=0;
    
    UILabel *moneyInfoLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 46, 20)];
    moneyInfoLable.userInteractionEnabled=YES;
    moneyInfoLable.text=@"金额";
    moneyInfoLable.textColor=[UIColor whiteColor];
    moneyInfoLable.font=[UIFont systemFontOfSize:13.0f];
    [moneyView addSubview:moneyInfoLable];
    
    UILabel *moneyLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 12, (kScreenWidth-1)/2-100, 20)];
    moneyLable.userInteractionEnabled=YES;
    moneyLable.text=[NSString stringWithFormat:@"%@",@"1"];
    moneyLable.textColor=[UIColor whiteColor];
    moneyLable.font=[UIFont systemFontOfSize:13.0f];
    moneyLable.textAlignment=NSTextAlignmentRight;
   [moneyView addSubview:moneyLable];
    
    lineView=[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-1)/2, 5, 1, 30)];
    lineView.backgroundColor=[UIColor whiteColor];
    
    integralView=[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-1)/2+1, 0, (kScreenWidth-1)/2, 44)];
    integralView.tag=1;

    UILabel *integralInfoLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 12, 46, 20)];
    integralInfoLable.text=@"积分";
    integralInfoLable.textColor=[UIColor whiteColor];
    integralInfoLable.font=[UIFont systemFontOfSize:13.0f];
    [integralView addSubview:integralInfoLable];
    
    UILabel *integralLable=[[UILabel alloc]initWithFrame:CGRectMake(80, 12, (kScreenWidth-1)/2-100, 20)];
    integralLable.text=[NSString stringWithFormat:@"%@",@"1"];
    integralLable.textColor=[UIColor whiteColor];
    integralLable.font=[UIFont systemFontOfSize:13.0f];
    integralLable.textAlignment=NSTextAlignmentRight;
    [integralView addSubview:integralLable];
}

#pragma mark --金额与积分视图手势
-(void)addGR:(UIView *)GRView{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview:)];
    [GRView addGestureRecognizer:tapRecognizer];
}

#pragma mark --手势事件
-(void)tapview:(UITapGestureRecognizer *)tamp{
    UIView *tapview=(UIView *)[tamp view];
    AcountBlanceVC *acountBlancevc=[[AcountBlanceVC alloc]init];
    if(tapview.tag == 0 ){
        acountBlancevc.moneyVCinfo=0;
    }else if(tapview.tag == 1){
        acountBlancevc.moneyVCinfo=1;
    }
    [self.navigationController pushViewController:acountBlancevc animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.Hidden=YES;
    doctorUser=[UserInfo sharedUserInfo];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headimage.png"];
    doctorimage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
    [self.doctorInformationTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
