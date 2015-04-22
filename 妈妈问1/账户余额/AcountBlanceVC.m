//
//  AcountBlanceVC.m
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AcountBlanceVC.h"
#import "BackView.h"

@interface AcountBlanceVC ()

{
//--------------blanceTableVC的文本数据
    NSArray *blanceDataArray;
}
@property(strong,nonatomic)UITableView *blanceTableVC;

@end

@implementation AcountBlanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataprocressing];
}

#pragma mark 杂乱数据
-(void)dataprocressing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    if(self.moneyVCinfo==0){
        self.titleLable.text=@"账户余额";
        blanceDataArray=@[@"收支明细",@"余额转出(提现)"];
    }else if(self.moneyVCinfo == 1){
        self.titleLable.text=@"我的金币";
        blanceDataArray=@[@"收支明细",@"向官方出售"];
    }
    
    self.blanceTableVC=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.blanceTableVC.delegate=self;
    self.blanceTableVC.dataSource=self;
    self.blanceTableVC.backgroundColor=[UIColor clearColor];
    self.blanceTableVC.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:self.blanceTableVC];
    
    
}

#pragma mark tableview datasource delegate
#pragma mark 行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

#pragma mark --cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *blanceTableVCInfo=@"blanceTableVCInfo";
    UITableViewCell *blanceTableVCCell=[tableView dequeueReusableCellWithIdentifier:blanceTableVCInfo];
    if(blanceTableVCCell == nil ){
        blanceTableVCCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blanceTableVCInfo];
        
    }
    blanceTableVCCell.backgroundColor=[UIColor clearColor];
    blanceTableVCCell.textLabel.text=blanceDataArray[indexPath.row];
    blanceTableVCCell.textLabel.textColor=[UIColor whiteColor];
    blanceTableVCCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return blanceTableVCCell;
}

#pragma mark -返回事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma maek ---
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
