//
//  CaseViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "CaseViewController.h"
#import "BackView.h"
#import "Constant.h"
#import "CaseTableViewCell.h"
#import "CaselistingTableViewCell.h"
#import "AFNetworking.h"
#import "UserInfo.h"

@interface CaseViewController ()
{
//-----------------------接收上传的病例表的时间,内容,诊断标签
    UILabel *timeLable;
    UILabel *caseContentLable;
    UILabel *caseDiagnoseLable;
    
//-------------------------接收内容的字典
    NSArray *caseDictionary;
    
//------------------------
    NSArray *dataArray0;
    NSMutableArray *dataarray1;
    
//---------------------------获取用户患者信息
    NSString *patientNameString;
    NSString *patientSubheadString;
}
@property(strong,nonatomic)UITableView *caseTableView;  //病例视图
@property(strong,nonatomic)UserInfo *doctorInformation;

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataProcessing];
}

#pragma mark --dataSource
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    dataarray1=[NSMutableArray array];
    self.doctorInformation=[UserInfo sharedUserInfo];
    
    self.caseTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 75, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    self.caseTableView.dataSource=self;
    self.caseTableView.delegate=self;
    self.caseTableView.backgroundColor=[UIColor clearColor];
    self.caseTableView.separatorStyle=UITableViewCellSeparatorStyleNone; //取消线条
    [self.view addSubview:self.caseTableView];
}

#pragma mark 视图将要出现时
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    [self paitintCase:@selector(loadData1:) targe:self];
}


#pragma mark ---tableview dataSource Delegate
#pragma mark 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataarray1.count+1;
}

#pragma mark  --cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *casetableviewInfo=@"casetableviewInfo";
    UITableViewCell *casetableviewCell1=[tableView dequeueReusableCellWithIdentifier:casetableviewInfo];
    if(casetableviewCell1 == nil){
        casetableviewCell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:casetableviewInfo];
    }
    if(indexPath.row == 0){
        CaseTableViewCell *casetableviewcell2=[CaseTableViewCell CaseTableViewCell];
        casetableviewcell2.patientNameLable.text=patientNameString;
        casetableviewcell2.patientSubheadLable.text=patientSubheadString;
        return casetableviewcell2;
        
    }else{
        
        CaselistingTableViewCell *caselistingcell=[CaselistingTableViewCell caselisting];
        [self addCaseListingCellContent];
        [caselistingcell.contentView addSubview:timeLable];
        [caselistingcell.contentView addSubview:caseContentLable];
        [caselistingcell.contentView addSubview:caseDiagnoseLable];
        
        return caselistingcell;
    }
}

#pragma mark caselistingcell content
-(void)addCaseListingCellContent{
    NSLog(@"--23----");
    
    if(dataarray1.count!=0){
        
        timeLable=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, kScreenWidth-40, 10)];
        timeLable.text=@"2014.01.23";
        timeLable.textColor=[UIColor whiteColor];
        timeLable.font=[UIFont systemFontOfSize:12.0f];
        
        caseContentLable=[[UILabel alloc]initWithFrame:CGRectMake(50, 25, kScreenWidth-80, 60)];
//        caseContentLable.text=[caseDictionary objectForKey:@"content"];
        caseContentLable.textColor=[UIColor whiteColor];
        caseContentLable.font=[UIFont systemFontOfSize:12.0f];
        caseContentLable.numberOfLines=0;
        CGSize size1=CGSizeMake(kScreenWidth-80, 0);
        CGSize caseSize=[caseContentLable sizeThatFits:size1];
        caseContentLable.frame=CGRectMake(50, 25, caseSize.width, caseSize.height);
        
        caseDiagnoseLable=[[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(caseContentLable.frame)+10, kScreenWidth-80, 20)];
 //       caseDiagnoseLable.text=[caseDictionary objectForKey:@"repportSuggestion"];
        caseDiagnoseLable.textColor=[UIColor whiteColor];
        caseDiagnoseLable.font=[UIFont systemFontOfSize:12.0f];
        caseDiagnoseLable.numberOfLines=0;
        CGSize size2=CGSizeMake(kScreenWidth-80, 0);
        CGSize caseDiag=[caseDiagnoseLable sizeThatFits:size2];
        caseDiagnoseLable.frame=CGRectMake(50, CGRectGetMaxY(caseContentLable.frame)+10, caseDiag.width, caseDiag.height);
    }
}

#pragma mark 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 146;
    }else
        return CGRectGetMaxY(caseDiagnoseLable.frame)+5;
}


#pragma mark 返回
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 获取病人病例的数据
-(void)paitintCase:(SEL)success1 targe:(id)targe{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSString *paitintCaseUrl=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/review/record/%@?uid=%@&sessionkey=%@",self.paitientuid,self.doctorInformation.userID,self.doctorInformation.sessionKey];
    [manager GET:paitintCaseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//--------------------------------------------------------------
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSLog(@"--%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//------------------------------------------------------------------------
        
    [targe performSelectorInBackground:success1 withObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

#pragma mark 请求成功
- (void)loadData1:(NSData *)data{
    
    NSDictionary *dataDictionary=(NSDictionary *)data;
    
    dataArray0=[[dataDictionary objectForKey:@"record"]objectForKey:@"patientReecord"];
    
    if(dataArray0.count!=0){
        [dataarray1 removeAllObjects];
        
         for(NSInteger i=0;i<dataArray0.count;i++){
             
             patientNameString=[dataArray0[i] objectForKey:@"name"];
             if([[dataArray0[i]objectForKey:@"gender"]isEqualToString:@"M"]){
                 patientSubheadString =[NSString stringWithFormat:@"男 %@岁 ",[dataArray0[i] objectForKey:@"age"]];
             }else{
                  patientSubheadString =[NSString stringWithFormat:@"nv %@岁 ",[dataArray0[i] objectForKey:@"age"]];
             }
             
             [dataarray1 addObject:dataArray0[i]];
             if([[dataarray1[i] objectForKey:@"inquiries"] count] != 0){
                 caseDictionary=[dataarray1[i] objectForKey:@"inquiries"][i];  //建议与描述
             }
         }
    }
    
    [self.caseTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

@end
