//
//  RecordViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RecordViewController.h"

#import "BackView.h"
#import "Constant.h"
#import "AFNetworking.h"
#import "UserInfo.h"

#import "AddPatientViewController.h"

@interface RecordViewController ()
{
    NSMutableArray *patientsArray; //患者用户名数组
    UILabel *midLable;
    
//    UISearchController *searchDC; // 搜索控件
//    UISearchBar *searchBar1;
//    NSMutableArray *searchData; //搜索数据
//    
//    NSArray *updateTimeArray;//更新时间数组
//    NSArray *upTimeArray;
//    
//    NSDate *nowTime;//获取当前时间
    
//    //----------------------
//    UIButton *myBtn;
//    UIButton *myBtn1;
//    UIButton *myBtn2;
//    UIButton *myBtn3;
    
    
    
}
@property (strong, nonatomic)UITableView *mytableview;

@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataDispose];
    
//    [self addSegmessageViewAction];
      //加载数据
//    [self addSearchBar1];
    
}

#pragma mark  数据处理
-(void)dataDispose{
    
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    patientsArray=[NSMutableArray array];
    
//----------------网络请求
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    midLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 120+(kScreenHeight-180-50)/2, kScreenWidth, 40)];
    midLable.text=@"暂无患者,请添加患者";
    midLable.textColor=[UIColor whiteColor];
    midLable.font=[UIFont systemFontOfSize:24.0f];
    midLable.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:midLable];
    
    
    self.mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 180, kScreenWidth, kScreenHeight-180-50) style:UITableViewStylePlain];
    self.mytableview.dataSource=self;
    self.mytableview.delegate=self;
    self.mytableview.backgroundColor=[UIColor clearColor];
    self.mytableview.tableFooterView=[[UIView alloc]init];
    self.mytableview.showsVerticalScrollIndicator=NO;
    self.mytableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mytableview];
    
    
    
//    myarray=@[@"晨晨妈妈",@"1"];
//    self.xCoordinatePointWeek=@[@[@"0",@"1",@"2",@"3",@"4",@"5"],@[@"0",@"1",@"2",@"3"]];
//    self.yCoordinatePointWeek=@[@[@"10",@"20",@"30",@"40",@"30",@"80"],@[@"10",@"20",@"30",@"40"]];
//    self.yValuePointWeek=@[@[@"10",@"20",@"30",@"40",@"30",@"60"],@[@"10",@"20",@"30",@"40"]];
//    
//    self.xCoordinatePointMonth=@[@[@"0",@"1",@"2"],@[@"0",@"1",@"2",@"3",@"4"]];
//    self.yCoordinatePointMonth=@[@[@"10",@"20",@"30"],@[@"10",@"20",@"30",@"40",@"30"]];
//    self.yValuePointMonth=@[@[@"10",@"20",@"30"],@[@"10",@"20",@"30",@"40",@"30"]];
//    
//    self.xCoordinatePointYear=@[@[@"0",@"1",@"2",@"3",@"4"],@[@"0",@"1",@"2",@"3",@"4"]];
//    self.yCoordinatePointYear=@[@[@"10",@"20",@"30",@"40",@"30"],@[@"10",@"20",@"30",@"40",@"30"]];
//    self.yValuePointYear=@[@[@"10",@"20",@"30",@"40",@"30"],@[@"10",@"20",@"30",@"40",@"30"]];
    
//    NSDate *date1=[NSDate dateWithTimeIntervalSinceNow:-60*68];
//    NSDate *date2=[NSDate date];
//    updateTimeArray=@[date1,date2];
//    nowTime=[NSDate date];
}



//#pragma mark 添加分段的按钮控件
//-(void)addSegmessageViewAction{
//    
//    myBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myBtn.frame=CGRectMake(0, 0, (kScreenWidth/4)-1, 40);
//    [myBtn setTitle:@"儿科" forState:UIControlStateNormal];
//    myBtn.tag =  0;
//    myBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
//    [myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [myBtn setBackgroundColor:[UIColor blueColor]];
//    [myBtn addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
//    [self.segmessageView addSubview:myBtn];
//    
//   myBtn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myBtn1.frame=CGRectMake(kScreenWidth/4, 0, (kScreenWidth/4)-1, 40);
//    [myBtn1 setTitle:@"产后" forState:UIControlStateNormal];
//    myBtn1.tag =  1;
//    myBtn1.titleLabel.font=[UIFont systemFontOfSize:13.0f];
//    [myBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [myBtn1 setBackgroundColor:[UIColor lightGrayColor]];
//    [myBtn1 addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
//    [self.segmessageView addSubview:myBtn1];
//    
//    myBtn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myBtn2.frame=CGRectMake(kScreenWidth/2, 0, (kScreenWidth/4)-1, 40);
//    [myBtn2 setTitle:@"怀孕" forState:UIControlStateNormal];
//    myBtn2.tag =  2;
//    myBtn2.titleLabel.font=[UIFont systemFontOfSize:13.0f];
//    [myBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [myBtn2 setBackgroundColor:[UIColor lightGrayColor]];
//    [myBtn2 addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
//    [self.segmessageView addSubview:myBtn2];
//    
//    myBtn3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    myBtn3.frame=CGRectMake(3*kScreenWidth/4, 0, (kScreenWidth/4)-1, 40);
//    [myBtn3 setTitle:@"备孕" forState:UIControlStateNormal];
//    myBtn3.tag =  3;
//    myBtn3.titleLabel.font=[UIFont systemFontOfSize:13.0f];
//    [myBtn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [myBtn3 setBackgroundColor:[UIColor lightGrayColor]];
//    [myBtn3 addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
//    [self.segmessageView addSubview:myBtn3];
//    
//    for(NSInteger i=0;i<3;i++){
//        UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake((i+1)*(kScreenWidth/4)-(i+1), 5, 1, 30)];
//        lineview.backgroundColor=[UIColor whiteColor];
//        [self.segmessageView addSubview:lineview];
//    }
//}
//
//#pragma mark 按钮方法
//-(void)actionIcon:(UIButton *)sender{
//    if(sender.tag==0){
//        [myBtn setBackgroundColor:[UIColor blueColor]];
//        [myBtn1 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn2 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn3 setBackgroundColor:[UIColor lightGrayColor]];
//        
//    }else if(sender.tag==1){
//        [myBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn1 setBackgroundColor:[UIColor blueColor]];
//        [myBtn2 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn3 setBackgroundColor:[UIColor lightGrayColor]];
//        
//    }else if(sender.tag==2){
//        [myBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn1 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn2 setBackgroundColor:[UIColor blueColor]];
//        [myBtn3 setBackgroundColor:[UIColor lightGrayColor]];
//        
//    }else{
//        [myBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn1 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn2 setBackgroundColor:[UIColor lightGrayColor]];
//        [myBtn3 setBackgroundColor:[UIColor blueColor]];
//    }
//    
//}


//
//#pragma mark 添加搜索按钮
//-(void)addSearchBar1{
//    searchBar1=[[UISearchBar alloc]initWithFrame:CGRectMake(20, -44, kScreenWidth-40, 40)];
//    searchBar1.delegate = self;
//    searchBar1.placeholder=@"搜索";
//    searchBar1.keyboardType = UIKeyboardTypeDefault;
//    searchBar1.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    searchBar1.showsCancelButton=NO;
//    
//    searchDC = [[UISearchController alloc]init];
//    searchDC.delegate = self;
//    
//    self.mytableview.tableHeaderView = searchBar1;
//    self.mytableview.contentOffset = CGPointMake(0, 0);
//   
//    
//    self.mytableview.dataSource=self;
//    self.mytableview.delegate=self;
//  
//}

#pragma mark tableview的代理
#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return searchData.count>0?searchData.count:myarray.count;
    return patientsArray.count;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell=[RecordTableViewCell RecordView];
    }
    [cell dataUpdate];  //调用自定义cell的方法
    
    if(patientsArray.count != 0){
//    cell.recordAskHeadImage.image
       cell.recordLableAskName.text=[[patientsArray[indexPath.row] objectForKey:@"friend"]objectForKey:@"name"] ;
        cell.recordAskTime.text=[[patientsArray[indexPath.row] objectForKey:@"lastRecord"] objectForKey:@"updatedTime"];
    
    }
    

//    int a=(int)[cell.recordAskTime.text integerValue];
//    
//    if(a>=0 && a<=60*60){
//        NSNumber *b=[NSNumber numberWithInt:a/60];
//        NSString *time=[NSString stringWithFormat:@"%@分钟前",b];
//        cell.recordAskTime.text=time;
//    }else if(a>60*60 && a<=60*60*24){
//        
//        NSTimeZone *time2 = [NSTimeZone localTimeZone];
//        NSTimeZone *timeZone2 = [NSTimeZone timeZoneWithName:time2.name];
//        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
//        [dateFormatter2 setTimeZone:timeZone2];
//        [dateFormatter2 setDateFormat:@"yyyy.MM.dd hh:mm"];
//        cell.recordAskTime.text=[dateFormatter2 stringFromDate:updateTimeArray[indexPath.row]];
//    }
   
    return cell;
}

  /*******  select row *******
   */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RecordHealthViewController *myHealthview=[[RecordHealthViewController alloc]init];
//    myHealthview.hidesBottomBarWhenPushed=YES;//隐藏tabbar
    
    //图表数据（ 周 月 年）
//    myHealthview.xCoordinatePointWeek2=self.xCoordinatePointWeek[indexPath.row];
//    myHealthview.yCoordinatePointWeek2=self.yCoordinatePointWeek[indexPath.row];
//    myHealthview.yValuePointWeek2=self.yValuePointWeek[indexPath.row];
//    
//    myHealthview.xCoordinatePointMonth2=self.xCoordinatePointMonth[indexPath.row];
//    myHealthview.yCoordinatePointMonth2=self.yCoordinatePointMonth[indexPath.row];
//    myHealthview.yValuePointMonth2=self.yValuePointMonth[indexPath.row];
//    
//    myHealthview.xCoordinatePointYear2=self.xCoordinatePointYear[indexPath.row];
//    myHealthview.yCoordinatePointYear2=self.yCoordinatePointYear[indexPath.row];
//    myHealthview.yValuePointYear2=self.yValuePointYear[indexPath.row];
    
    
    HealthYunViewController *healthYun=[[HealthYunViewController alloc]init];
    healthYun.hidesBottomBarWhenPushed=YES;
    if(patientsArray.count != 0 ){
        healthYun.askID=[[patientsArray[indexPath.row] objectForKey:@"friend"] objectForKey:@"userID"];
    }
    
    
    [self.navigationController pushViewController:healthYun animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark  row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//#pragma mark searchBar的数据
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
//{
//    NSLog(@"%lu",(unsigned long)[myarray count]);
//    if (searchText!=nil && searchText.length>0) {
//        searchData= [NSMutableArray array];
//        for (NSString *tempStr in myarray) {
//            if ([tempStr rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
//                [searchData addObject:tempStr];
//                //NSLog(@"%lu",(unsigned long)[searchData count]);
//            }
//        }
//        [self.mytableview reloadData];
//    }
//    else
//    {
//        searchData = [NSMutableArray arrayWithArray:myarray];
//        [self.mytableview reloadData];
//    }
//}

//#pragma mark searchBar的text开始编辑
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    searchBar1.showsCancelButton=YES;
//}
//
//#pragma mark searchBar取消键方法
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    [self searchBar:searchBar1 textDidChange:nil];
//    searchBar1.placeholder=@"搜索";
//    searchBar1.showsCancelButton=NO;
//    [searchBar1 resignFirstResponder];
//}



//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [searchBar1 endEditing:YES];
//    
//}



#pragma mark --网络请求---好友列表
-(void)networkReuest{
    
    NSString *paitintCaseUrl=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/friends/health/records?uid=%@&sessionkey=%@",self.doctor.userID,self.doctor.sessionKey];
    
    [self.manager GET:paitintCaseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=(NSDictionary *)responseObject;
        if([[dict objectForKey:@"code"]integerValue ]==0){
            [patientsArray removeAllObjects];
            if([[dict objectForKey:@"records"]count]!=0){
                for(NSInteger i=0; i<[[dict objectForKey:@"records"]count];i++){
                    [ patientsArray addObject:[dict objectForKey:@"records"][i] ];
                }
                midLable.hidden=YES;
            }else
                midLable.hidden=NO;
            [self.mytableview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
    
}



#pragma mark 隐藏导航栏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    
    self.doctor=[UserInfo sharedUserInfo];
    [self networkReuest];
    

}

#pragma mark --- 搜索 添加患者事件
- (IBAction)addAsk:(UIButton *)sender {
    if(sender.tag == 0 ){
        
    }else if(sender.tag == 1){
        AddPatientViewController *patientsVC=[[AddPatientViewController alloc]init];
        [self.navigationController pushViewController:patientsVC animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
