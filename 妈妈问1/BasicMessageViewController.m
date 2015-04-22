//
//  BasicMessageViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "BasicMessageViewController.h"
#import "TabBarViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "NSString+psd.h"

@interface BasicMessageViewController ()
{
    NSInteger imageInfo;//确定点击的图片
    NSDictionary *doctorXinxi;
}
@property(strong,nonatomic)UserInfo *doctorInformation; //注册成功后的医生信息

//tableview显示医院的的数据视图
@property(strong,nonatomic)UITableView *contentTableView;
@property(strong,nonatomic)NSArray *dataSource;

//接收OutpatientViewController的数据
@property(strong,nonatomic)NSArray *scheduleArray;

@end

@implementation BasicMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dataProcessing];
}

#pragma mark -杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    //给医院后的图片添加手势
    [self addTapGR:self.hospitalImage];
    [self addTapGR:self.officeImage];
    [self addTapGR:self.zhichengImage];
    [self addTapGR:self.menzhenTimeImage];
    
    //需要弹出的小tableview 和view
    self.contentTableView=[[UITableView alloc]init];
    self.contentTableView.showsVerticalScrollIndicator=NO;
    self.contentTableView.dataSource=self;
    self.contentTableView.delegate=self;
    imageInfo=-1;
    
    self.doctorInformation=[UserInfo sharedUserInfo];
    
}


#pragma mark --返回 -完成按钮事件
- (IBAction)actionIcon:(UIButton *)sender {
    if(sender.tag==0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        

        if (self.doctorNameText.text.length == 0) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.hospitalLable.text.length == 0){
             [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入医院" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.officeLable.text.length == 0){
              [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入科室" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.zhichenLable.text.length == 0){
              [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入职称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else if(self.menzhenTimeLable.text.length == 0){
              [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入时间" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]show];
            
        }else{
            [self doctorRegister];
        }
    }
}

#pragma mark --图片的手势
-(void)addTapGR:(UIImageView *)myimageview{
    UITapGestureRecognizer *imageTapGR=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapRecnizer:)];
    [myimageview addGestureRecognizer:imageTapGR];
    
}

#pragma mark 手势方法
-(void)imageTapRecnizer:(UITapGestureRecognizer *)parm{
    
    UIImageView *parmimageGR=(UIImageView *)[parm view];
    
    if(parmimageGR.tag==0){

        imageInfo=0;
        self.contentTableView.hidden=NO;
        self.contentTableView.frame=CGRectMake(80, 196, kScreenWidth-160, 80);
        self.dataSource=@[@"上海中医药大学附属岳阳中西医结合医院",@"虹口区妇幼医院",@"复旦大学附属妇产科医院",@"上海第二医科大学附属第九人民医院"];
        [self.contentTableView reloadData];
        [self.view addSubview:self.contentTableView];
        
    }else if(parmimageGR.tag==1){

        imageInfo=1;
        self.contentTableView.hidden=NO;
        self.contentTableView.frame=CGRectMake(80, 242, kScreenWidth-160, 80);
        self.dataSource=@[@"儿科",@"妇科",@"产科"];
        [self.contentTableView reloadData];
        [self.view addSubview:self.contentTableView];
        
        
    }else if(parmimageGR.tag==2){
        imageInfo=2;
        self.contentTableView.hidden=NO;
        self.contentTableView.frame=CGRectMake(80, 288, kScreenWidth-160, 80);
        self.dataSource=@[@"主任医师",@"副主任医师",@"主治医师"];
        [self.contentTableView reloadData];
        [self.view addSubview:self.contentTableView];
        
    }else{
        self.contentTableView.hidden=YES;
        OutpatientViewController *outpatientView=[[OutpatientViewController alloc]init];
        outpatientView.delegate=self;
        
        [self.navigationController pushViewController:outpatientView animated:YES];
    }
}

#pragma mark TableView delegate -DataSource
#pragma mark 块
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

#pragma mark cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *contentInfo=@"yiliaoxinxi";
    UITableViewCell *mycell=[tableView dequeueReusableCellWithIdentifier:contentInfo];
    if(mycell == nil){
        mycell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contentInfo];
    }
    mycell.textLabel.text=self.dataSource[indexPath.row];
    mycell.accessoryType=UITableViewCellAccessoryNone;
    return mycell;
}

#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(imageInfo==0){
        self.hospitalLable.text=self.dataSource[indexPath.row];
        self.contentTableView.hidden=YES;

    }else if(imageInfo ==1 ){
        self.officeLable.text=self.dataSource[indexPath.row];
        self.contentTableView.hidden=YES;
        
    }else if(imageInfo == 2){
        self.zhichenLable.text=self.dataSource[indexPath.row];
        self.contentTableView.hidden=YES;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.contentTableView.hidden=YES;
    [self.doctorNameText endEditing:YES];
}

#pragma mark  OutpatientViewController的代理
-(void)transfer:(NSArray *)valueArray{
    self.scheduleArray=valueArray;
    self.menzhenTimeLable.text=@"1";
    self.menzhenTimeLable.hidden=YES;
}



#pragma mark 注册接口
-(void)doctorRegister{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
   
    NSDictionary *dict = @{@"phoneNumber": self.doctorChenni, @"password" : [[self.doctorPsd sha256Encrypt] base64Encrypt],@"name":self.doctorNameText.text,@"hospital":self.hospitalLable.text,@"department":self.officeLable.text,@"title":self.zhichenLable.text,@"workTime":self.scheduleArray};
    
    [manager POST:@"http://115.159.49.31:9000/doctor/register" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
        
        NSDictionary *doctorinfo=(NSDictionary *)responseObject;
        doctorXinxi=[doctorinfo objectForKey:@"doctor"];
        
        
        if(responseObject != nil){
            
            self.doctorInformation.userID=[doctorXinxi objectForKey:@"doctorID"];
            self.doctorInformation.sessionKey=[doctorXinxi objectForKey:@"sessionKey"];
            self.doctorInformation.userlevel=[doctorXinxi objectForKey:@"level"];
            self.doctorInformation.jid=[doctorXinxi objectForKey:@"jid"];
            self.doctorInformation.imToken=[doctorXinxi objectForKey:@"imToken"];
            self.doctorInformation.userName=[doctorXinxi objectForKey:@"name"];
            self.doctorInformation.userTelephone=[doctorXinxi objectForKey:@"cellPhone"];
            self.doctorInformation.userOffice=[doctorXinxi objectForKey:@"department"];
            self.doctorInformation.userHospital=[doctorXinxi objectForKey:@"hospital"];
          //  self.doctorInformation.userZhichen=[doctorXinxi objectForKey:@"title"];
            
            
            TabBarViewController *tabBarVier=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"tabBarView"];
                [self.navigationController pushViewController:tabBarVier animated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
