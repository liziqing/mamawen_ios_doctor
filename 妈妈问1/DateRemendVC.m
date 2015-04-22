//
//  DateRemendVC.m
//  妈妈问1
//
//  Created by netshow on 15/3/27.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DateRemendVC.h"
#import "BackView.h"
#import "UserInfo.h"
#import "DateData.h"
#import "AFNetworking.h"
#import "RemindListTableVCCell.h"

#import "DetailContentViewController.h"


@interface DateRemendVC ()
{
//--------------日历视图--增加日程提醒的视图
    CalendarView *_sampleView;
    DetailContentViewController *detailVC;
    
//---------接收日程的数组---覆盖系统自带的删除图标--标记要删除的cell
    NSMutableArray *dateDataArray;
    UIImageView *deletImageview;
    NSInteger deletecellInfo;
 
//-----------选择日期后的日历
    NSDate *riliDate;
    NSString *dateStr2;  //选择的日期
    NSMutableArray *DateOneArray;
    
}
@property(strong,nonatomic)UITableView *dateTableView;
@property(strong,nonatomic)UserInfo *docter;
@property(strong,nonatomic)DateData *dateRemind;
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;

@end

@implementation DateRemendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
  
//-----------------------------标题
    NSDate *titleName=[NSDate date];
    NSDateFormatter *titleformatter=[[NSDateFormatter alloc]init];
    [titleformatter setDateFormat:@"yyyy MMMM"];
    self.titleLable.text=[titleformatter stringFromDate:titleName];
    
//-------------------------------网络请求-------------
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
//--------------------------日程提醒个数-----
    dateDataArray=[NSMutableArray array];
    DateOneArray=[NSMutableArray array];
    
    
    self.dateTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.dateTableView.dataSource=self;
    self.dateTableView.delegate=self;
    self.dateTableView.backgroundColor=[UIColor clearColor];
    self.dateTableView.tableFooterView=[[UIView alloc]init];
    self.dateTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.dateTableView];
 
//-------------------------日程提醒详细界面
     detailVC=[[DetailContentViewController alloc]init];

}

#pragma mark --datasource delegate
#pragma mark--块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return 1;
    }else
        return DateOneArray.count;
}

#pragma mark cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *dateremendVCInfo=@"dateremendVCInfo";
    UITableViewCell *dateremendVCCell=[tableView dequeueReusableCellWithIdentifier:dateremendVCInfo];
    if(dateremendVCCell == nil){
        dateremendVCCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dateremendVCInfo];
        
    }if(indexPath.section ==0){
        _sampleView= [[CalendarView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenWidth-20)];
        if(dateDataArray.count != 0){
            _sampleView.dateListArray=dateDataArray;
        }
        _sampleView.delegate = self;
        [_sampleView setBackgroundColor:[UIColor clearColor]];

        _sampleView.calendarDate = [NSDate date];
        [dateremendVCCell.contentView addSubview:_sampleView];
        
        dateremendVCCell.selectionStyle=UITableViewCellSelectionStyleNone;
        dateremendVCCell.backgroundColor=[UIColor clearColor];
        
        return dateremendVCCell;
        
    }else if(indexPath.section == 1){
        RemindListTableVCCell *remindlistCell=[RemindListTableVCCell remindListTableVCCell];
        if(DateOneArray.count != 0){
            
            NSString *timestr=[[DateOneArray[indexPath.row] objectForKey:@"remindTime"] substringWithRange:NSMakeRange(0, 5)];
            remindlistCell.timeLable.text=timestr;
            remindlistCell.nameLable.text=[DateOneArray[indexPath.row] objectForKey:@"patientName"];
            
            deletImageview=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, 80, 50)];
            deletImageview.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
            [remindlistCell.contentView addSubview:deletImageview];
            
        }
        return remindlistCell;
        
    }else {
        
        dateremendVCCell.backgroundColor=[UIColor clearColor];
        return dateremendVCCell;
    }
}

#pragma mark row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 ){
        return kScreenWidth-20;
    }else
        return 50;
}

#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        
        detailVC.finishInfo=2;
        
        self.dateRemind.titleString=[DateOneArray[indexPath.row] objectForKey:@"title"];
        self.dateRemind.timeString=[NSString stringWithFormat:@"%@ %@",[DateOneArray[indexPath.row] objectForKey:@"startDate"],[[DateOneArray[indexPath.row] objectForKey:@"remindTime"] substringWithRange:NSMakeRange(0, 5)]];
        self.dateRemind.patientString=[DateOneArray[indexPath.row] objectForKey:@"patientName"];
        if([[DateOneArray[indexPath.row] objectForKey:@"remindMe"]integerValue]==1){
            self.dateRemind.remindMe=YES;
            self.dateRemind.remindPatient=YES;
        }else{
            self.dateRemind.remindMe=NO;
            self.dateRemind.remindPatient=NO;
        }
        
        NSString *str1=[NSString stringWithFormat:@"%@%@%@",[[DateOneArray[indexPath.row] objectForKey:@"endDate"]substringWithRange:NSMakeRange(0, 4)],[[DateOneArray[indexPath.row] objectForKey:@"endDate"]substringWithRange:NSMakeRange(5, 2)],[[DateOneArray[indexPath.row] objectForKey:@"endDate"]substringWithRange:NSMakeRange(8, 2)]];
        NSString *str2=[NSString stringWithFormat:@"%@%@%@",[[DateOneArray[indexPath.row] objectForKey:@"startDate"]substringWithRange:NSMakeRange(0, 4)],[[DateOneArray[indexPath.row] objectForKey:@"startDate"]substringWithRange:NSMakeRange(5, 2)],[[DateOneArray[indexPath.row] objectForKey:@"startDate"]substringWithRange:NSMakeRange(8, 2)]];
        self.dateRemind.remindNumString=[NSString stringWithFormat:@"%i",[str1 integerValue]-[str2 integerValue]+1];
        self.dateRemind.contentString=[DateOneArray[indexPath.row] objectForKey:@"content"];
        self.dateRemind.reminderID=[DateOneArray[indexPath.row] objectForKey:@"reminderID"];
        
        self.dateRemind.remindTimeString=[DateOneArray[indexPath.row] objectForKey:@"remindTime"];
        self.dateRemind.startTimeString=[DateOneArray[indexPath.row] objectForKey:@"startDate"];
        self.dateRemind.endTimeString=[DateOneArray[indexPath.row] objectForKey:@"endDate"];
        
        
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -------移动cell  进行编辑
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
  
        if (editingStyle != UITableViewCellEditingStyleDelete)
            {
                return;
            }
     if(DateOneArray.count!=0){
         
//--------------------1.先删除指定Section的Row的内容
    deletecellInfo=[[DateOneArray[indexPath.row] objectForKey:@"reminderID"]integerValue];
    [dateDataArray removeObject:DateOneArray[indexPath.row]];
    [DateOneArray removeObjectAtIndex:indexPath.row];
    
    [deletImageview removeFromSuperview];

//---------2.再删除表单视图对应项的视图
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self deleteRemind];
    }
}

#pragma mark -- 删除改为中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

#pragma mark 判定哪一行可进行编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return NO;
    }else
        return YES;
}



#pragma mark 改变视图标题---日历视图代理
-(void)tappedOnDate:(NSDate *)selectedDate titleString:(NSString *)str{
    self.titleLable.text=str;
    riliDate=selectedDate;
    [self networkRequset2];
    
}

#pragma mark --返回\完成 按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        detailVC.finishInfo=1;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}


-(void)networkRequset2{
    
    NSDictionary *dict=@{@"uid":self.docter.userID,@"sessionkey":self.docter.sessionKey};
    [_manager GET:@"http://115.159.49.31:9000/doctor/reminder/get?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=(NSDictionary *)responseObject;
        
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyyMMdd"];
        dateStr2=[dateformatter stringFromDate:riliDate];
        
        NSString *str1=[dateStr2 substringWithRange:NSMakeRange(0, 4)];
        NSString *str2=[dateStr2 substringWithRange:NSMakeRange(4, 2)];
        NSString *str3=[dateStr2 substringWithRange:NSMakeRange(6, 2)];
        
        
        if([[dict objectForKey:@"code"]intValue]==0 ){
            NSArray *myarray=[dict objectForKey:@"reminders"];
            if(myarray.count !=0){
                [dateDataArray removeAllObjects];
                [DateOneArray removeAllObjects];
                
                for(NSInteger i=0;i<myarray.count;i++){
                    [dateDataArray addObject:myarray[i]];
                    
                    NSString *str5=[myarray[i] objectForKey:@"startDate"];
                    NSString *str6=[str5 substringWithRange:NSMakeRange(0, 4)];
                    NSString *str7=[str5 substringWithRange:NSMakeRange(5, 2)];
                    NSString *str8=[str5 substringWithRange:NSMakeRange(8, 2)];
                    
                    if([str1 isEqualToString:str6] && [str2 isEqualToString:str7] && [str3 isEqualToString:str8]){
                        
                        [DateOneArray addObject:myarray[i]];
                    }
                }
                
                [self.dateTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败---%@",error);
    }];
}

#pragma mark --- 网络请求--- 获取日程列表
-(void)networkRequset{
    
    NSDictionary *dict=@{@"uid":self.docter.userID,@"sessionkey":self.docter.sessionKey};
    [_manager GET:@"http://115.159.49.31:9000/doctor/reminder/get?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=(NSDictionary *)responseObject;
    
        NSDate *date1=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyyMMdd"];
        dateStr2=[dateformatter stringFromDate:date1];
        
        NSString *str1=[dateStr2 substringWithRange:NSMakeRange(0, 4)];
        NSString *str2=[dateStr2 substringWithRange:NSMakeRange(4, 2)];
        NSString *str3=[dateStr2 substringWithRange:NSMakeRange(6, 2)];
        
        
        if([[dict objectForKey:@"code"]intValue]==0 ){
            NSArray *myarray=[dict objectForKey:@"reminders"];
            if(myarray.count !=0){
                [dateDataArray removeAllObjects];
                [DateOneArray removeAllObjects];
                
                for(NSInteger i=0;i<myarray.count;i++){
                [dateDataArray addObject:myarray[i]];
                    
                    NSString *str5=[myarray[i] objectForKey:@"startDate"];
                    NSString *str6=[str5 substringWithRange:NSMakeRange(0, 4)];
                    NSString *str7=[str5 substringWithRange:NSMakeRange(5, 2)];
                    NSString *str8=[str5 substringWithRange:NSMakeRange(8, 2)];
                    
                    if([str1 isEqualToString:str6] && [str2 isEqualToString:str7] && [str3 isEqualToString:str8]){
                        
                        [DateOneArray addObject:myarray[i]];
                    }
                }
                [_sampleView removeFromSuperview];
                [self.dateTableView reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败---%@",error);
    }];
}

#pragma mark ------删除日程
-(void)deleteRemind{
    
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/reminder/delete?uid=%i&sessionkey=%@",[self.docter.userID intValue],self.docter.sessionKey];
    NSDictionary *dict=@{@"reminderID":@(deletecellInfo)};
    
    [_manager POST :urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
        
        [_sampleView removeFromSuperview];
        [self.dateTableView reloadData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}


#pragma mark 视图将要出现
-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.docter=[UserInfo sharedUserInfo];
    self.dateRemind=[DateData shareDateData];
    [self networkRequset];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
