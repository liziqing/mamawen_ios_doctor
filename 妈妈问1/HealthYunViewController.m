//
//  HealthYunViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "HealthYunViewController.h"
#import "BackView.h"
#import "CaseViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "LineChartView.h"
#import "AllData.h"

#define kTubiaoHeight 30
#define kTubiaoWight 30

@interface HealthYunViewController ()<UIScrollViewDelegate>

{
    AFHTTPRequestOperationManager *manager;//网络请求
    
    
//---------------图表----
    UIScrollView *tubiaoScrollVC1;
    UIScrollView *tubiaoScrollVC2;
    UIScrollView *tubiaoScrollVC3;
    
    
    
}
@property(strong,nonatomic)UserInfo *doctor;

//周的数据
@property(strong,nonatomic)NSMutableArray *xCoordinatePointWeek;
@property(strong,nonatomic)NSArray *yCoordinatePointWeek;
@property(strong,nonatomic)NSMutableArray *ybaobaosg;
@property(strong,nonatomic)NSMutableArray *ybaobaotz;
@property(strong,nonatomic)NSMutableArray *ybaobaotw;


@property(strong,nonatomic)NSArray *bzzValuemax;
@property(strong,nonatomic)NSArray *bzzValuemin;

//-----------图表
@property(strong,nonatomic)LineChartView *lineView1;
@property(strong,nonatomic)LineChartView *lineView2;
@property(strong,nonatomic)LineChartView *lineView3;

//----------图表的背视图
@property(strong,nonatomic)UIImageView *backimageVC1;
@property(strong,nonatomic)UIImageView *backimageVC2;
@property(strong,nonatomic)UIImageView *backimageVC3;

@property(strong,nonatomic)UIView *yzuobiao1;
@property(strong,nonatomic)UIView *yzuobiao2;
@property(strong,nonatomic)UIView *yzuobiao3;

@end

@implementation HealthYunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];

}

#pragma mark --杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.healthTableView.dataSource=self;
    self.healthTableView.delegate=self;
    self.healthTableView.backgroundColor=[UIColor clearColor];
    self.healthTableView.tableFooterView=[[UIView alloc]init];
    
    self.doctor=[UserInfo sharedUserInfo];
    manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    self.xCoordinatePointWeek=[NSMutableArray array];
    
    AllData *bbdata=[[AllData alloc]init];
    self.bzzValuemax=bbdata.bbsgArray;
   self.bzzValuemin=bbdata.bbsgminArray;
 //   self.bzzValuemin=[NSMutableArray array];
    
    for(NSInteger i=0;i<36;i++){
        [self.xCoordinatePointWeek addObject:[NSString stringWithFormat:@"%i",i+1]];
     //   [self.bzzValuemin addObject:@"30"];
    }
    
    self.yCoordinatePointWeek=@[@"0",@"15",@"30",@"45",@"60"];

    self.ybaobaosg=[NSMutableArray array];
    self.ybaobaotz=[NSMutableArray array];
    self.ybaobaotw=[NSMutableArray array];
    
 
}

#pragma mark healthYunTableView delegate -dataSource
#pragma mark --行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark -- cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *healthYunInfo=@"healthYunInfo";
    HealthYunTableViewCell *healthyuncell=[tableView dequeueReusableCellWithIdentifier:healthYunInfo];
    if(healthyuncell == nil){
        healthyuncell=[HealthYunTableViewCell HealthYunTableViewCell];
    }
   
    [self BingliViewGR:healthyuncell.bingliImageView];
    
    [healthyuncell.contentView addSubview:self.backimageVC1];
    [healthyuncell.contentView addSubview:self.yzuobiao1];
    [healthyuncell.contentView addSubview:tubiaoScrollVC1];
    
    [healthyuncell.contentView addSubview:self.backimageVC2];
    [healthyuncell.contentView addSubview:self.yzuobiao2];
    [healthyuncell.contentView addSubview:tubiaoScrollVC2];
    
    [healthyuncell.contentView addSubview:self.backimageVC3];
    [healthyuncell.contentView addSubview:self.yzuobiao3];
    [healthyuncell.contentView addSubview:tubiaoScrollVC3];
    
    
    
    return healthyuncell;
}

#pragma mark -- 图表
-(void)tubiao{
    //------------------------图表视图-------------
    self.backimageVC1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 80, kScreenWidth-20,(self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.backimageVC1.backgroundColor=[UIColor whiteColor];
    self.backimageVC1.alpha=0.2;
    self.backimageVC1.userInteractionEnabled=YES;
    self.backimageVC1.tag=1;
    
    //--------添加纵坐标
    self.yzuobiao1=[[UIView alloc]initWithFrame:CGRectMake(10, 80, 20,(self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.yzuobiao1.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable.text=@"身高";
    titleLable.font=[UIFont systemFontOfSize:13.0f];
    titleLable.textColor=[UIColor whiteColor];
    [self.yzuobiao1 addSubview:titleLable];
    
//    NSInteger cishu1=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu1-1];
//        cishu1--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao1 addSubview:ylable];
//    }
    
    tubiaoScrollVC1 = [[UIScrollView alloc]initWithFrame:CGRectMake(30, 110, kScreenWidth-60, (self.yCoordinatePointWeek.count)*kTubiaoHeight)];
    tubiaoScrollVC1.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC1.bounces=NO;
    tubiaoScrollVC1.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC1 addSubview:[self chart1]];
    
#pragma mark  ---图表2
    self.backimageVC2=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC1.frame)+20, kScreenWidth-20, (self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.backimageVC2.backgroundColor=[UIColor whiteColor];
    self.backimageVC2.alpha=0.2;
    self.backimageVC2.userInteractionEnabled=YES;
    self.backimageVC2.tag=2;
    
    //--------添加纵坐标
    self.yzuobiao2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC1.frame)+20, 20, (self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.yzuobiao2.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable2.text=@"体重";
    titleLable2.font=[UIFont systemFontOfSize:13.0f];
    titleLable2.textColor=[UIColor whiteColor];
    [self.yzuobiao2 addSubview:titleLable2];
    
//    NSInteger cishu2=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu2-1];
//        cishu2--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao2 addSubview:ylable];
//    }
    
    
    self.backimageVC3=[[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC2.frame)+20, kScreenWidth-20, (self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.backimageVC3.backgroundColor=[UIColor whiteColor];
    self.backimageVC3.alpha=0.2;
    self.backimageVC3.userInteractionEnabled=YES;
    self.backimageVC3.tag=3;
    
    //--------添加纵坐标
    self.yzuobiao3=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.backimageVC2.frame)+20, 20,(self.yCoordinatePointWeek.count+1)*kTubiaoHeight)];
    self.yzuobiao2.backgroundColor=[UIColor clearColor];
    
    UILabel *titleLable3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    titleLable3.text=@"头围";
    titleLable3.font=[UIFont systemFontOfSize:13.0f];
    titleLable3.textColor=[UIColor whiteColor];
    [self.yzuobiao3 addSubview:titleLable3];
    
//    NSInteger cishu3=self.yCoordinatePointWeek.count;
//    for(NSInteger i=0;i<self.yCoordinatePointWeek.count;i++){
//        UILabel *ylable=[[UILabel alloc]initWithFrame:CGRectMake(0, 22+i*15, 20, 15)];
//        ylable.textColor=[UIColor whiteColor];
//        ylable.text=self.yCoordinatePointWeek[cishu3-1];
//        cishu3--;
//        ylable.font=[UIFont systemFontOfSize:9];
//        [self.yzuobiao3 addSubview:ylable];
//    }
    
    
    
    tubiaoScrollVC2 = [[UIScrollView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.backimageVC1.frame)+50, kScreenWidth-60,  (self.yCoordinatePointWeek.count)*kTubiaoHeight)];
    tubiaoScrollVC2.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC2.bounces=NO;
    tubiaoScrollVC2.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC2 addSubview:[self chart2]];
    
    tubiaoScrollVC3 = [[UIScrollView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.backimageVC2.frame)+50, kScreenWidth-50,  (self.yCoordinatePointWeek.count)*kTubiaoHeight)];
    tubiaoScrollVC3.showsHorizontalScrollIndicator=NO;
    tubiaoScrollVC3.bounces=NO;
    tubiaoScrollVC3.backgroundColor=[UIColor clearColor];
    [tubiaoScrollVC3 addSubview:[self chart3]];

}



-(LineChartView *)chart1{
    self.lineView1 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,kTubiaoWight*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kTubiaoHeight)];
    self.lineView1.backgroundColor=[UIColor clearColor];
    self.lineView1.color=[UIColor whiteColor];
    self.lineView1.x=self.xCoordinatePointWeek;
    self.lineView1.y=self.yCoordinatePointWeek;
    self.lineView1.bzValue=self.bzzValuemax;
    self.lineView1.bzValuemin=self.bzzValuemin;
    
    [self.lineView1 setChartData:self.ybaobaosg];
    
    tubiaoScrollVC1.contentSize=CGSizeMake(self.lineView1.bounds.size.width, self.lineView1.bounds.size.height);
    [self.lineView1.layer setNeedsDisplay];
    return self.lineView1;
}

-(LineChartView *)chart2{
    self.lineView2 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,kTubiaoWight*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kTubiaoHeight)];
    self.lineView2.backgroundColor=[UIColor clearColor];
    self.lineView2.color=[UIColor whiteColor];
    self.lineView2.x=self.xCoordinatePointWeek;
    self.lineView2.y=self.yCoordinatePointWeek;
    self.lineView2.bzValue=self.bzzValuemax;
    self.lineView2.bzValuemin=self.bzzValuemin;
    
    [self.lineView2 setChartData:self.ybaobaotz];
    
    tubiaoScrollVC2.contentSize=CGSizeMake(self.lineView2.bounds.size.width, self.lineView2.bounds.size.height);
    
    [self.lineView2.layer setNeedsDisplay];
    return self.lineView2;
}

-(LineChartView *)chart3{
    self.lineView3 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,kTubiaoWight*(self.xCoordinatePointWeek.count-1), (self.yCoordinatePointWeek.count-1)*kTubiaoHeight)];
    self.lineView3.backgroundColor=[UIColor clearColor];
    self.lineView3.color=[UIColor whiteColor];
    self.lineView3.x=self.xCoordinatePointWeek;
    self.lineView3.y=self.yCoordinatePointWeek;
    self.lineView3.bzValue=self.bzzValuemax;
    self.lineView3.bzValuemin=self.bzzValuemin;
    
    [self.lineView3 setChartData:self.ybaobaotw];
    tubiaoScrollVC3.contentSize=CGSizeMake(self.lineView3.bounds.size.width, self.lineView3.bounds.size.height);
    [self.lineView3.layer setNeedsDisplay];
    return self.lineView3;
}



#pragma mark 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGRectGetMaxY(self.backimageVC3.frame)+60;
}

#pragma mark  --查看病例view的手势跳转
-(void)BingliViewGR:(UIView *)myview{
    UITapGestureRecognizer *BLrwcognize=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bingliGR)];
    [myview addGestureRecognizer:BLrwcognize];
}
-(void)bingliGR{
    
    CaseViewController *caseview=[[CaseViewController alloc]init];
    caseview.paitientuid=self.askID;
    [self.navigationController pushViewController:caseview animated:YES];
}



//#pragma mark --网络请求 获取问诊用户个人数据
//-(void)obtainUserAskInformation:(SEL)sucess3 myfailder3:(SEL)failder3 targer:(id)targer{
//    
//    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/inquiry/%@/detail/uid=%i&sessionkey=%i",self.askID,[self.doctor.userID intValue],123];
//    
//    [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
//        NSLog(@"--%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        
//        if(responseObject != nil){
//            
//            
//            [targer performSelectorInBackground:sucess3 withObject:responseObject];
//            
//            
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//        [targer performSelectorInBackground:failder3 withObject:error];
//    }];
//}


#pragma mark  获取图表数据
-(void)networkRequest{
    
    AFHTTPRequestOperationManager *tbmanager=[AFHTTPRequestOperationManager manager];
    tbmanager.requestSerializer=[AFJSONRequestSerializer serializer];
    tbmanager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    NSString *url=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/friend/%@/health/record?uid=%@&sessionkey=%@",self.askID,self.doctor.userID,self.doctor.sessionKey];
    NSDictionary *dict=@{@"category":@"宝宝",@"subCategory":@"身高"};
    
    [tbmanager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict1=(NSDictionary *)responseObject;
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaosg removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaosg addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaosg addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaosg addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaosg addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaosg addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        [self tubiao];
        
        [self.healthTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
    
    NSDictionary *dict1=@{@"category":@"宝宝",@"subCategory":@"体重"};
    [tbmanager POST:url parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict1=(NSDictionary *)responseObject;
        NSLog(@"身高%@",responseObject);
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaotz removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaotz addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaotz addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotz addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaotz addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotz addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        [self tubiao];
        
        [self.healthTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
    
    NSDictionary *dict2=@{@"category":@"宝宝",@"subCategory":@"头围"};
    [tbmanager POST:url parameters:dict2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict1=(NSDictionary *)responseObject;
        NSLog(@"身高%@",responseObject);
        if([[dict1 objectForKey:@"message"]isEqualToString:@"success"]){
            NSArray *myarray=[dict1 objectForKey:@"records"];
            if(myarray.count != 0){
                [self.ybaobaotw removeAllObjects];
                NSMutableArray *cycleArray=[NSMutableArray array];
                [cycleArray removeAllObjects];
                NSMutableArray *valueArray=[NSMutableArray array];
                [valueArray removeAllObjects];
                NSString *temp;
                NSString *tempvalue;
                for(NSInteger j=0 ;j<myarray.count;j++){
                    
                    [cycleArray addObject:[myarray[j] objectForKey:@"cycle"]];
                    [valueArray addObject:[myarray[j] objectForKey:@"value"]];
                }
                
                for(NSInteger a=0;a<cycleArray.count;a++){
                    for(NSInteger b=a;b<cycleArray.count;b++){
                        if([cycleArray[a] integerValue]>[cycleArray[b] integerValue]){
                            temp=cycleArray[a];
                            cycleArray[a]=cycleArray[b];
                            cycleArray[b]=temp;
                            
                            tempvalue=valueArray[a];
                            valueArray[a]=valueArray[b];
                            valueArray[b]=tempvalue;
                            
                        }
                    }
                    
                }
                if([cycleArray[0] integerValue] ==0){
                    [cycleArray removeObjectAtIndex:0];
                    [valueArray removeObjectAtIndex:0];
                }
                
                for(NSInteger i=1;i<=[[cycleArray lastObject]integerValue];i++){
                    if(i<=cycleArray.count){
                        for(NSInteger j=0;j<cycleArray.count;j++){
                            if(i == [cycleArray[j]integerValue] ){
                                [self.ybaobaotw addObject:valueArray[j]];
                                
                            }
                            
                        }
                        
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if(i == [cycleArray[i-1]integerValue] ){
                                break;
                            }else if([cycleArray[i-1]integerValue]>cycleArray.count){
                                [self.ybaobaotw addObject:@"0"];
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotw addObject:@"0"];
                            }
                        }
                        
                    }else if(i>cycleArray.count){
                        
                        for(NSInteger k=0;k<cycleArray.count;k++){
                            if(i ==[cycleArray[k]integerValue]){
                                [self.ybaobaotw addObject:valueArray[k]];
                                
                            }
                        }
                        for(NSInteger l=0;l<cycleArray.count;l++){
                            if([[cycleArray lastObject]integerValue] == i){
                                break;
                            }else if(i !=[cycleArray[l]integerValue] ){
                                [self.ybaobaotw addObject:@"0"];
                                break;
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        [self tubiao];
        
        [self.healthTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"_erreo__%@",error);
    }];
}



#pragma mark 成功加载数据
-(void)loadData:(NSData *)data{
    
}

#pragma mark 数据加载失败
-(void)defented:(NSData *)data{
    
}




#pragma mark 返回按钮
- (IBAction)healthviewback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden=YES;
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
