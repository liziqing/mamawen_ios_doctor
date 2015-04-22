//
//  RecordHealthViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RecordHealthViewController.h"
#import "LineChartView.h"
#import "BackView.h"


@interface RecordHealthViewController ()
{
    UIView *myview2;//
    UIView *myview3;
    
    UIScrollView *myscrollviewchart;//myview2上的scrollview
    UIScrollView *myscrollviewchart2;
    NSArray *ypoint;//y坐标轴上的所有点
    NSArray *xpoint;//x轴上的所有点
    
    NSArray *yvalue;//y轴上得数据点
    NSArray *xvalue;//x轴上得数据点
    LineChartView* lineChart;//图表view1
    LineChartView *lineChart2;//图表view2
}

@end

@implementation RecordHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self dataDispose];
    [self addScrollViewContent];
    [self addMyscrollview];
    [myscrollviewchart addSubview:[self chart1]];
    [myscrollviewchart2 addSubview:[self chart2]];
}

#pragma mark 数据处理
-(void)dataDispose
{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.myscrollview.backgroundColor=[UIColor clearColor];
    [self.view addSubview:self.myscrollview];
    
    self.contactPatient.layer.cornerRadius=5;
    self.contactPatient.layer.masksToBounds=YES;
    [self.view addSubview:self.contactPatient];
}

#pragma mark navigationview上得返回按钮
- (IBAction)returnAction:(UIButton *)sender
{
    self.tabBarController.tabBar.hidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark navigationview上得分段按钮
- (IBAction)segmentAction:(UISegmentedControl *)sender
{
   if(sender.selectedSegmentIndex==0){
        xpoint=self.xCoordinatePointWeek2;
        ypoint=self.yCoordinatePointWeek2;
        yvalue=self.yValuePointWeek2;
        [lineChart removeFromSuperview];
        [UIView animateWithDuration:30.0f animations:^{
            [myscrollviewchart addSubview:[self chart1]];
        }];
        
        
        [lineChart2 removeFromSuperview];
        [myscrollviewchart2 addSubview:[self chart2]];
        
    }else if(sender.selectedSegmentIndex==1){
        xpoint=self.xCoordinatePointMonth2;
        ypoint=self.yCoordinatePointMonth2;
        yvalue=self.yValuePointMonth2;
        [lineChart removeFromSuperview];
        [myscrollviewchart addSubview:[self chart1]];
        
        [lineChart2 removeFromSuperview];
        [myscrollviewchart2 addSubview:[self chart2]];
        
    }else{
        xpoint=self.xCoordinatePointYear2;
        ypoint=self.yCoordinatePointYear2;
        yvalue=self.yValuePointYear2;
        [lineChart removeFromSuperview];
        [myscrollviewchart addSubview:[self chart1]];
        
        [lineChart2 removeFromSuperview];
        [myscrollviewchart2 addSubview:[self chart2]];
       
    }       
}

#pragma mark 主界面上scrollview中的内容
-(void)addScrollViewContent{
    //第一个view
    UIView *myview1=[[UIView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 50)];
    myview1.backgroundColor=[UIColor whiteColor];
    myview1.layer.cornerRadius=2;
    myview1.layer.masksToBounds=YES;
    
    UIImageView *myview1imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 30, 30)];
    myview1imageview.image=[UIImage imageNamed:@""];
    [myview1 addSubview:myview1imageview];
    
    UILabel *view1mylable=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 80, 30)];
    view1mylable.text=@"查看病例";
    view1mylable.font=[UIFont systemFontOfSize:18.0f];
    view1mylable.textColor=[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
    [myview1 addSubview:view1mylable];
    
    [self.myscrollview addSubview:myview1];
    
    //第二个view
    myview2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(myview1.frame)+10, kScreenWidth-20, 180)];
    myview2.backgroundColor=[UIColor whiteColor];
    
    UILabel *view2lable1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    view2lable1.text=@"体重";
    view2lable1.font=[UIFont systemFontOfSize:14.0f];
    view2lable1.textColor=[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
    [myview2 addSubview:view2lable1];
    
    UILabel *view2lable2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view2lable1.frame)+10, 10, 120, 20)];
    view2lable2.text=[NSString stringWithFormat:@"最后记录为%.2f kg",2.64];
    view2lable2.font=[UIFont systemFontOfSize:10.0f];
    view2lable2.textColor=[UIColor darkGrayColor];
    [myview2 addSubview:view2lable2];
    
    [self.myscrollview addSubview:myview2];
    
    //第3个view
    myview3=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(myview2.frame)+10, kScreenWidth-20, 180)];
    myview3.backgroundColor=[UIColor whiteColor];
    
    UILabel *view3lable1=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    view3lable1.text=@"身高";
    view3lable1.font=[UIFont systemFontOfSize:14.0f];
    view3lable1.textColor=[UIColor colorWithRed:0.57 green:0.57 blue:0.57 alpha:1];
    [myview3 addSubview:view3lable1];
    
    UILabel *view3lable2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view2lable1.frame)+10, 10, 120, 20)];
    view3lable2.text=[NSString stringWithFormat:@"最后记录为%.1fcm",50.4];
    view3lable2.font=[UIFont systemFontOfSize:10.0f];
    view3lable2.textColor=[UIColor darkGrayColor];
    [myview3 addSubview:view3lable2];
    
    [self.myscrollview addSubview:myview3];
    
    self.myscrollview.contentSize=CGSizeMake(kScreenWidth, CGRectGetMaxY(myview3.frame)+10);
    
    
}

#pragma mark myview2 and myview3-chartSCrollView
-(void)addMyscrollview{
    myscrollviewchart =[[UIScrollView alloc]initWithFrame:CGRectMake(10, 35, myview2.bounds.size.width-20, 150)];
    myscrollviewchart.bounces=NO;
    myscrollviewchart.showsHorizontalScrollIndicator=NO;
    [myview2 addSubview:myscrollviewchart];
    
    myscrollviewchart2 = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 35, myview3.bounds.size.width-20, 150)];
    myscrollviewchart2.bounces=NO;
    myscrollviewchart2.showsHorizontalScrollIndicator=NO;
    [myview3 addSubview:myscrollviewchart2];
    
    xpoint=self.xCoordinatePointWeek2;
    ypoint=self.yCoordinatePointWeek2;
    yvalue=self.yValuePointWeek2;
    
}

#pragma mark  myview2-chartview
-(LineChartView *)chart1
{
    lineChart = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0,myview2.bounds.size.width-20, 130)];
    lineChart.color=[UIColor redColor];
    lineChart.x=xpoint;
    lineChart.y=ypoint;
    [lineChart setChartData:yvalue];
    myscrollviewchart.contentSize=CGSizeMake(lineChart.bounds.size.width, lineChart.bounds.size.height);
    
    [lineChart.layer setNeedsDisplay];
    return lineChart;
    
}

#pragma mark  myview3-chartview
-(LineChartView *)chart2
{
    lineChart2 = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, myview3.bounds.size.width-20, 130)];
    lineChart2.x=xpoint;
    lineChart2.y=ypoint;
    [lineChart2 setChartData:yvalue];
    myscrollviewchart2.contentSize=CGSizeMake(lineChart2.bounds.size.width, lineChart2.bounds.size.height);
    
    return lineChart2;
    
}

#pragma mark 联系患者按钮方法
- (IBAction)contactPatientIcon:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
