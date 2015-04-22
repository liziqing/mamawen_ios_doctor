//
//  AffirmViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AffirmViewController.h"
#import "ChatViewController.h"
#import "UpLoadPhoteViewController.h"


//#import "FriendsModel.h"
//#import "FRDListDBManger.h"



@interface AffirmViewController ()
{
    NSInteger mycellHeight;     //行高
    AFHTTPRequestOperationManager *manager;//网络请求
    NSDictionary *judgeAsk; //判断问题是否被接
    
//--------------------------接收用户个人数据
    NSDictionary *dictionData;   //接收请求的数据
    NSDictionary *userInfomationDictionary;   //解析获得的用户问诊信息
    
//----------------警告框
    UIAlertView *alertView1;   //确认接诊
    UIAlertView *alertView2;  //医生等级为0
    
    
    
}
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation AffirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataset];

}

#pragma mark   数据
-(void)dataset
{
    //背景视图
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    //内容Tableview
    self.affirmclinicalTableView.delegate=self;
    self.affirmclinicalTableView.dataSource=self;
    self.affirmclinicalTableView.tableFooterView=[[UIView alloc]init];
    self.affirmclinicalTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.affirmclinicalTableView];
    
    #pragma mark --初始化医生信息及网络请求
    manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //headview
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame=CGRectMake(20, 25, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-15, 35, 120,30 )];
    title.center=CGPointMake(kScreenWidth/2, 35);
    title.text=@"确认";
    title.textAlignment=NSTextAlignmentCenter;
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont systemFontOfSize:20.0f];
    [self.view addSubview:title];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame)+15, kScreenWidth, 1)];
    line.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:line];
    
}

#pragma mark 返回按钮方法
-(void)backview{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableview source delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myaffirmtableviewcell=@"affirm";
    AffirmClinicalTableViewCell *mycell=[tableView dequeueReusableCellWithIdentifier:myaffirmtableviewcell];
    if(mycell==nil){
        
        mycell=[AffirmClinicalTableViewCell AffirmClinicalTableViewCell];
        mycell.delegate=self;

        mycell.askName3=self.askName2;
        mycell.askSubhead3=self.askSubhead2;  //副标题
        mycell.askIntegral3=self.askIntegral2;
        mycell.askString3=self.askstring;
        mycell.askPictureNumber3=self.askPictureNumber2;
    }
    mycell.backgroundColor=[UIColor clearColor];
      [mycell addOther]; //调用自定义cell的方法
    
    mycell.selectionStyle=UITableViewCellAccessoryNone;
    return mycell;
}

#pragma mark  -cell代理方法
-(void)changeCellHeight:(NSInteger)cellHeight{
    mycellHeight=cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return mycellHeight;
}

#pragma mark 确认接诊按钮
- (IBAction)affirmInquiryBtnClick:(id)sender {
    if([self.doctor.userlevel integerValue]==0){
       alertView1= [[UIAlertView alloc]initWithTitle:@"消息提示" message:@"请上传胸牌，完善信息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView1 show];
    }else{

        [self doctorAffirmClinical];

    }
}

#pragma mark 警告框代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView==alertView2){
        if(buttonIndex == 0){
            NSLog(@"11111");
        }else{
        }
    }else if(alertView == alertView1){
        if(buttonIndex == 1 ){
            UpLoadPhoteViewController *upxiongpai=[[UpLoadPhoteViewController alloc]init];
            [self.navigationController pushViewController:upxiongpai animated:YES];
        }
    }
}


#pragma mark 确认接诊  向网络请求数据  -让此问题不能在被接诊
-(void)doctorAffirmClinical{
    
    NSDictionary *dict = @{@"inquiryID": self.askID};
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/inquiry/recept?uid=%i&sessionkey=%i",[self.doctor.userID intValue],123];
    
    [manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"--%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);

        if(responseObject != nil){
            judgeAsk=(NSDictionary *)responseObject;
            
//-------------------------he----------------------
            if([[judgeAsk objectForKey:@"message"]isEqualToString:@"success"]){
                ChatViewController *VC = [[ChatViewController alloc] init];
                
//                FriendsModel *fm = [[FriendsModel alloc] init];
//                fm.patientid = self.patientuid;
//                fm.doctoerid = _doctor.userID;
                
//                fm.name =
//                fm.phone =
//                fm.portraitPath =
                
//                FRDListDBManger *dbm = [FRDListDBManger sharedManager];
//                if (![dbm isExists:fm.phone]) {
//                    [dbm insertModel:fm];
//                    // 上传无服务i
//                }
                
                VC.patientID = self.patientuid.integerValue;
                VC.sessionkey =self.patientsessionkey;
                VC.inquiryID = self.patientinquiryID.integerValue;
                VC.uid = _doctor.userID;
                self.navigationController.navigationBarHidden=NO;
                [self.navigationController pushViewController:VC animated:YES];
            }else{
                alertView2= [[UIAlertView alloc]initWithTitle:@"提示" message:@"这问题已被接诊" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
               [alertView2 show];
            }
//-----------------------he-----------------------------
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
    
    }];
}

#pragma mark --网络请求 获取问诊用户个人数据
-(void)obtainUserAskInformation:(SEL)sucess3 myfailder3:(SEL)failder3 targer:(id)targer{
    
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/inquiry/%@/detail?uid=%i&sessionkey=%i",self.askID,[self.doctor.userID intValue],123];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSLog(@"--%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if(responseObject != nil){
            [targer performSelectorInBackground:sucess3 withObject:responseObject];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [targer performSelectorInBackground:failder3 withObject:error];
    }];
    
}



#pragma mark 成功加载数据
-(void)loadData:(NSData *)data{
    dictionData=(NSDictionary *)data;
    //------用户数据
    if([[dictionData objectForKey:@"message"]isEqualToString:@"success"]){
        userInfomationDictionary=[dictionData objectForKey:@"inquiry"];
        if(userInfomationDictionary.count!=0){
            self.askName2=[[userInfomationDictionary objectForKey:@"user"]objectForKey:@"userName"];
            self.askSubhead2=[userInfomationDictionary objectForKey:@"department"];
            self.askstring=[userInfomationDictionary objectForKey:@"content"];
            
        }
    }
    [self.affirmclinicalTableView reloadData];
}

#pragma mark 数据加载失败
-(void)defented:(NSData *)data{
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
   self.doctor=[UserInfo sharedUserInfo];
   [self obtainUserAskInformation:@selector(loadData:) myfailder3:@selector(defented:) targer:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
