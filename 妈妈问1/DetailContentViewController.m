//
//  DetailContentViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/13.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DetailContentViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "DateData.h"

#import "DateRemendMyVCell.h"
#import "DateRemendContentCell.h"

//------------------he------------
#import "FriendsModel.h"
#import "FRDListDBManger.h"
//-------------------he------------

@interface DetailContentViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
//-------------------------------时间选择器
    UIView *myScreenView;   // 覆盖的视图
    UIView *dateView;
    NSInteger datevcInfo;
    UIDatePicker *mydatePicker;
    UIPickerView *myPickerVC;
    NSArray *pickerArray;
    UIButton *cancelBtn;
    UIButton *determineBtn;
    NSDate* nowdate;          //显示提醒时间

    NSDateFormatter *dateFormatter; //日期格式

    UITableView *currentViewTableview;//当前视图的tableview
    DateRemendMyVCell *dateremendmycell;

//--------日程列表数组---
    NSArray *dataArray;
    UISwitch *swithOn1;
    UISwitch *swithOn2;
    UILabel *contentLable;
    CGSize size2;
    
    NSMutableArray *patientsListArray;  //----患者昵称
    NSMutableArray *patientsID;         //----患者ID数组
    NSString *patientID;
    
}
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
@property(strong,nonatomic)UserInfo *doctor;
@property(strong,nonatomic)DateData *dateremind;
@property(assign,nonatomic)NSInteger nextView;


@end

@implementation DetailContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataprecessing];
}

#pragma mark 杂乱数据
-(void)dataprecessing{
//-----------------------------------背景视图
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.finishBtn.layer.cornerRadius=3;
    self.finishBtn.layer.masksToBounds=YES;
    
    contentLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    contentLable.textColor=[UIColor whiteColor];
    contentLable.font=[UIFont systemFontOfSize:13.0f];
    
//--------------------------------------------网络请求
    _manager=[AFHTTPRequestOperationManager manager];
    _manager.responseSerializer=[AFJSONResponseSerializer serializer];
    _manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
//------------------------选择时间视图数据
    datevcInfo=0;
    myScreenView=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    myScreenView.backgroundColor = [UIColor whiteColor];
    myScreenView.alpha=0.5;
    
    dateView=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-202, kScreenWidth, 202)];
    dateView.backgroundColor=[UIColor whiteColor];
    [[[[UIApplication sharedApplication]windows] lastObject] addSubview:myScreenView];
    [[[[UIApplication sharedApplication]windows] lastObject] addSubview:dateView];
    myScreenView.hidden=YES;
    dateView.hidden=YES;
    
    pickerArray=@[@"1",@"2",@"3",@"4"];
    mydatePicker=[[UIDatePicker alloc]init];
    myPickerVC=[[UIPickerView alloc]initWithFrame:CGRectZero];
    
    cancelBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    determineBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];

   dataArray=@[@[@"标题"],@[@"时间"],@[@"患者"],@[@"提醒我",@"提醒患者",@"提醒次数"]];
   patientsListArray=[NSMutableArray array];
    patientsID= [NSMutableArray array];
    
//----------------------------当前视图的 tableview
    currentViewTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-160) style:UITableViewStylePlain];
    currentViewTableview.backgroundColor=[UIColor clearColor];
    currentViewTableview.dataSource=self;
    currentViewTableview.delegate=self;
    currentViewTableview.showsVerticalScrollIndicator=NO;
    currentViewTableview.tableFooterView=[[UIView alloc]init];
    currentViewTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:currentViewTableview];
    
//-------------------------------switch 控件
    swithOn1=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-90, 10, 43, 21)];
    swithOn2=[[UISwitch alloc]initWithFrame:CGRectMake(kScreenWidth-90, 10, 43, 21)]; 
    
}


#pragma mark - Table view data source
#pragma mark 块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==3){
        return 3;
    }else
        return 1;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailContentTableViewCell *detailContentTableViewCell=[DetailContentTableViewCell detailContentTableViewCell];
    dateremendmycell=[DateRemendMyVCell DateRemendMyVCell];
    dateremendmycell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
   
    static NSString *detailContentIdentifier=@"detailContent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailContentIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailContentIdentifier];

    }
    
    if(indexPath.section==0 ){
        detailContentTableViewCell.detailTitle.text=dataArray[indexPath.section][indexPath.row];
        if(self.dateremind.titleString.length !=0){
            detailContentTableViewCell.detailLable.text=self.dateremind.titleString;
        }
        
        return detailContentTableViewCell;
 
    }else if(indexPath.section==1){
        detailContentTableViewCell.detailTitle.text=dataArray[indexPath.section][indexPath.row];
        if(self.dateremind.timeString.length != 0){
            detailContentTableViewCell.detailLable.text=self.dateremind.timeString;
        }else{
            
        }
        
        return detailContentTableViewCell;
        
    }else if(indexPath.section==2){
        detailContentTableViewCell.detailTitle.text=dataArray[indexPath.section][indexPath.row];
        
        if(self.dateremind.patientString.length != 0){
            detailContentTableViewCell.detailLable.text=self.dateremind.patientString;
        }

        return detailContentTableViewCell;
        
    }else if(indexPath.section==3 && indexPath.row==2){
        detailContentTableViewCell.detailTitle.text=dataArray[indexPath.section][indexPath.row];
        
        if(self.dateremind.remindNumString.length != 0){
            detailContentTableViewCell.detailLable.text=self.dateremind.remindNumString;
        }

        return detailContentTableViewCell;
        
    }else if(indexPath.section==3 && indexPath.row==0){
        
        dateremendmycell.titleLable.text=@"提醒我";
        [dateremendmycell.contentView addSubview:swithOn1];
        swithOn1.tag=0;
        [swithOn1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        return dateremendmycell;
        
    }else if(indexPath.section==3 && indexPath.row==1){
        dateremendmycell.titleLable.text=@"提醒患者";
        [dateremendmycell.contentView addSubview:swithOn2];
        swithOn2.tag=1;
        [swithOn2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        return dateremendmycell;
        
    }else if(indexPath.section == 4){
        DateRemendContentCell *dateRemendCell=[DateRemendContentCell dateRemendContentCell];
        
        if(self.dateremind.contentString.length != 0){
            contentLable.text=self.dateremind.contentString;
            contentLable.numberOfLines=0;
            CGSize size1=CGSizeMake(kScreenWidth, 0);
            size2=[contentLable sizeThatFits:size1];
            contentLable.frame=CGRectMake(0, 0, size2.width, size2.height);
            
            [dateRemendCell.contentView addSubview:contentLable];
        }

        
        return dateRemendCell;
        
    }else{
        cell.backgroundColor=[UIColor clearColor];
        return cell;
   }
}

#pragma mark switch
-(void)switchAction:(UISwitch *)sender{
    if(sender.tag==0){
        if(sender.on){
            self.dateremind.remindMe=YES;
        }else
            self.dateremind.remindMe=NO;
        
    }else {
        if(sender.on){
            self.dateremind.remindPatient=YES;
        }else
            self.dateremind.remindPatient=NO;
    }
}


#pragma mark section head Height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

#pragma mark   --行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 4){
        return 40+size2.height;
    }else
        return 50;
}

#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailAmendViewController *detailAmend1=[[DetailAmendViewController alloc]init];
    
    if(indexPath.section == 1){
        datevcInfo=1;
        myScreenView.hidden=NO;
        dateView.hidden=NO;
        [self addDatePicker];
        
    }else if(indexPath.section == 2){
        datevcInfo =2;
        myScreenView.hidden=NO;
        dateView.hidden=NO;
        [self addDatePicker];
        
        
        
        
    }else if(indexPath.section ==0 /*|| indexPath.section==2 */|| indexPath.section == 4){
        if(indexPath.section==0){
            detailAmend1.titleStr=@"标题修改";
    
        }else if(indexPath.section == 2) {
            detailAmend1.titleStr=@"患者修改";
            
        }else {
            detailAmend1.titleStr=@"内容修改";
        }

        [self.navigationController pushViewController:detailAmend1 animated:YES];
        
    }else if(indexPath.section==3 && indexPath.row == 2){
        datevcInfo=3;
        myScreenView.hidden=NO;
        dateView.hidden=NO;
        [self addDatePicker];
        
    }
    [currentViewTableview deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -- 时间选择器视图
-(void)addDatePicker{
    if(datevcInfo == 1){
        
        mydatePicker.backgroundColor=[UIColor whiteColor];
        mydatePicker.frame=CGRectMake(0, 40, kScreenWidth, 80);
        mydatePicker.datePickerMode=UIDatePickerModeDateAndTime;
        mydatePicker.locale=[NSLocale currentLocale];
        mydatePicker.minimumDate=[[NSDate alloc]initWithTimeIntervalSinceNow:0];
        
        NSDate *nowdate3=[NSDate date];
        NSTimeZone *time1 = [NSTimeZone localTimeZone];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter1 setTimeZone:time1];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm"];
        self.dateremind.timeString = [dateFormatter1 stringFromDate:nowdate3];
        
        [mydatePicker addTarget:self action:@selector(mydateSelect:) forControlEvents:UIControlEventValueChanged];
        [dateView addSubview:mydatePicker];
        
    }else if (datevcInfo == 2){
        myPickerVC.backgroundColor=[UIColor whiteColor];
        myPickerVC.frame=CGRectMake(0, 40, kScreenWidth, 162);
        
        self.dateremind.patientString=@"1";
        
        myPickerVC.showsSelectionIndicator = YES;
        myPickerVC.dataSource=self;
        myPickerVC.delegate=self;
        [dateView addSubview:myPickerVC];
        
        
    }else if(datevcInfo == 3){
        myPickerVC.backgroundColor=[UIColor whiteColor];
        myPickerVC.frame=CGRectMake(0, 40, kScreenWidth, 162);
        
        self.dateremind.remindNumString=@"1";
        
        myPickerVC.showsSelectionIndicator = YES;
        myPickerVC.dataSource=self;
        myPickerVC.delegate=self;
        [dateView addSubview:myPickerVC];
        
    }
    
    cancelBtn.tag=0;
    cancelBtn.frame=CGRectMake(0, 0, kScreenWidth/2, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:cancelBtn];
    
    determineBtn.tag=1;
    determineBtn.frame=CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 40);
    [determineBtn setTitle:@"确定" forState:UIControlStateNormal];
    [determineBtn addTarget:self action:@selector(Btn:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:determineBtn];

}

#pragma mark --弹出视图的取消、确定 按钮事件
-(void)Btn:(UIButton *)sender{
    if(sender.tag==0){
 
        if(datevcInfo ==1){
            [mydatePicker removeFromSuperview];
        }else{
            [myPickerVC removeFromSuperview];
        }
        myScreenView.hidden=YES;
        dateView.hidden=YES;
        
    }else{

        
        if(datevcInfo==1){
            [mydatePicker removeFromSuperview];
            
        }else{
            NSDate *date1;
            if([self.dateremind.remindNumString isEqualToString:@"1"]){
               date1=[[NSDate alloc]initWithTimeInterval:0 sinceDate:nowdate];
                
            }else if([self.dateremind.remindNumString isEqualToString:@"2"]){
                date1=[[NSDate alloc]initWithTimeInterval:24*60*60 sinceDate:nowdate];
                
            }else if([self.dateremind.remindNumString isEqualToString:@"3"]){
                date1=[[NSDate alloc]initWithTimeInterval:2*24*60*60 sinceDate:nowdate];
            }else if([self.dateremind.remindNumString isEqualToString:@"4"]){
                date1=[[NSDate alloc]initWithTimeInterval:3*24*60*60 sinceDate:nowdate];
            }
                NSTimeZone *time1 = [NSTimeZone localTimeZone];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
                [dateFormatter1 setTimeZone:time1];
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
                self.dateremind.endTimeString = [dateFormatter1 stringFromDate:date1];

                
                [dateFormatter1 setDateFormat:@"hh:mm:00"];
                self.dateremind.remindTimeString=[dateFormatter1 stringFromDate:date1];
                
            }
            [myPickerVC removeFromSuperview];
        }
    myScreenView.hidden=YES;
    dateView.hidden=YES;
    [currentViewTableview reloadData];
   
}

#pragma mark  ---- 时间选择器事件
-(void)mydateSelect:(id)sender{
    UIDatePicker * control = (UIDatePicker*)sender;
    nowdate = control.date;
    
    NSTimeZone *time2 = [NSTimeZone systemTimeZone];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setTimeZone:time2];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd hh:mm"];
    self.dateremind.timeString = [dateFormatter2 stringFromDate:nowdate];
    
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    self.dateremind.startTimeString=[dateFormatter2 stringFromDate:nowdate];

}

#pragma mark ------------pickerView代理
#pragma mark ---------1、pickerView块
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mark -- 2、-----pickerView行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(datevcInfo == 2){
        if(patientsListArray.count != 0){
            return patientsListArray.count;
        }else
            return 0;
        
    }else{
        return pickerArray.count;
    }
}

#pragma mark---3、-----PickerView的代理方法--设置Row的标题
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(datevcInfo == 2){
        if(patientsListArray.count != 0){
            return patientsListArray[row];
        }else
            return @"";
    }else
        return pickerArray[row];
}

#pragma mark------4、-----PickerView的代理方法--选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(datevcInfo == 2){
        self.dateremind.patientString=patientsListArray[row];
        patientID=patientsID[row];
        NSLog(@"---%@",patientID);
    }else
        self.dateremind.remindNumString=pickerArray[row];
    
}


#pragma mark section headView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeadView=[[UIView alloc]init];
    sectionHeadView.backgroundColor=[UIColor clearColor];
    return sectionHeadView;
}


//---------------------------------he---------------
#pragma mark--- 读取本地患者列表
- (void)quiryDataFromDB{
   NSMutableArray *_patients = [[FRDListDBManger sharedManager] fetchAll];

    for (FriendsModel *fm in _patients) {
        [patientsListArray addObject:fm.name == nil? @"无名" : fm.name];
        [patientsID addObject:@""];
    }
    
    
}

//-----------------------------------he-----------



#pragma mark 视图将要出现时
-(void)viewWillAppear:(BOOL)animated{
    self.doctor=[UserInfo sharedUserInfo];
    self.dateremind=[DateData shareDateData];
    
    [self huoquPatientList];
    
    if(self.finishInfo ==2){
        if(self.dateremind.remindMe == YES){
            swithOn1.on=YES;
        }else
            swithOn1.on=NO;
        if(self.dateremind.remindPatient == YES){
            swithOn2.on=YES;
        }else
            swithOn2.on=NO;
    }else{
        swithOn1.on=NO;
        swithOn2.on=YES;
    }
    
    [currentViewTableview reloadData];
}



#pragma mark -- 添加日程日程
-(void)addDate{
    
    NSString *str1=[NSString stringWithFormat:@"%@",patientID];
    
    if(str1.length==0){
         NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/custom/sms/send?uid=%@&sessionkey=%@",self.doctor.userID,self.doctor.sessionKey];
        NSDictionary *dict=@{@"content":self.dateremind.contentString,@"phoneNumber":patientID};
        [_manager POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"1");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"2");
        }];
        
    }
    if([str1 integerValue] != 0){
    
        NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/reminder/add?uid=%i&sessionkey=%i",[self.doctor.userID intValue],123];
    
        NSDictionary *dict=@{@"title":self.dateremind.titleString,@"patientName":self.dateremind.patientString,@"content":self.dateremind.contentString,@"startDate":self.dateremind.startTimeString,@"endDate":self.dateremind.endTimeString,@"remindTime":self.dateremind.remindTimeString,@"remindMe":@(self.dateremind.remindMe),@"doctorID":self.doctor.userID,@"userID":patientID};
        
    //    NSData *data=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    //    NSLog(@"--------dta----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        [_manager POST :urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
           NSLog(@"responseObject--%@",(NSDictionary *)responseObject);

         [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"失败");
        }];
    }
}


#pragma mark -- -修改日程提醒
-(void)amendRemind{
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/reminder/update?uid=%i&sessionkey=%@",[self.doctor.userID intValue],self.doctor.sessionKey];
    
    NSDictionary *dict=@{@"reminderID":self.dateremind.reminderID,@"title":self.dateremind.titleString,@"patientName":self.dateremind.patientString,@"content":self.dateremind.contentString,@"startDate":self.dateremind.startTimeString,@"endDate":self.dateremind.endTimeString,@"remindTime":self.dateremind.remindTimeString,@"remindMe":@(self.dateremind.remindMe),@"doctorID":self.doctor.userID,@"userID":@"1"};
    
    NSLog(@"----%@",dict);
    
    
    [_manager POST :urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
                NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
                NSLog(@"成功");
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark -- 获取患者列表
-(void)huoquPatientList{
    NSString *paitintCaseUrl=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/friends/get?uid=%@&sessionkey=%@&page=0&limit=10",self.doctor.userID,self.doctor.sessionKey];

    [self.manager GET:paitintCaseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=(NSDictionary *)responseObject;
        if([[dict objectForKey:@"code"]integerValue ]==0){
            [patientsListArray removeAllObjects];
            [patientsID removeAllObjects];
            
            [self quiryDataFromDB];
            if([[dict objectForKey:@"friends"]count]!=0){
                for(NSInteger i=0; i<[[dict objectForKey:@"friends"]count];i++){
                    [patientsListArray addObject:[[dict objectForKey:@"friends"][i] objectForKey:@"name" ]];
                    [patientsID addObject:[[dict objectForKey:@"friends"][i] objectForKey:@"userID"]];
                    
                }
                NSLog(@"----%@",patientsID);
               
            }
           [currentViewTableview reloadData];
      }
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}


#pragma mark   --返回,完成按钮按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else
        if(self.finishInfo == 1){

            if(self.dateremind.titleString.length !=0 && self.dateremind.timeString.length !=0 && self.dateremind.patientString.length != 0 && self.dateremind.remindNumString.length != 0){
                
            [self addDate];
       
            }
        }else if(self.finishInfo == 2){
            if(self.dateremind.titleString.length !=0 && self.dateremind.timeString.length !=0 && self.dateremind.patientString.length != 0 && self.dateremind.remindNumString.length != 0){
                
                [self amendRemind];
                
            }
        }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}


@end
