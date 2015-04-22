//
//  SettingViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "SettingViewController.h"
#import "BackView.h"
#import "RevampPsdVC.h"
#import "BindingAcountVC.h"
#import "SetCell.h"
#import "InfomationVC.h"

@interface SettingViewController ()
{
    NSArray *textArray;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark --杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.backBtn.layer.cornerRadius=3;
    self.backBtn.layer.masksToBounds=YES;
    
    textArray=@[@[@"绑定账号",@"修改密码"],@[@"新消息通知",@"清楚缓存"],@[@"关于我们"]];
    
    self.setingtableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-150) style:UITableViewStylePlain];
    self.setingtableview.dataSource=self;
    self.setingtableview.delegate=self;
    self.setingtableview.backgroundColor=[UIColor clearColor];
    self.setingtableview.tableFooterView=[[UIView alloc]init];
    self.setingtableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.setingtableview];
}

#pragma mark ---tableview Datasource-delegate
#pragma mark ---块
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark --行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
        
    }else if(section == 1){
        return 2;
        
    }else {
        return 1;
    }
}

#pragma mark -cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *setingInfo=@"setingInfo";
    SetCell *setcell=[tableView dequeueReusableCellWithIdentifier:setingInfo];
    if(setcell == nil){
        setcell=[SetCell SetCell];
    }
    setcell.titleLable.text=textArray[indexPath.section][indexPath.row];
    if((indexPath.section ==0 && indexPath.row ==1) || (indexPath.section ==1 && indexPath.row ==1) || (indexPath.section==2)){
        setcell.line.hidden=YES;
    }
    setcell.selectionStyle=UITableViewCellSelectionStyleNone;
    return setcell;
}

#pragma mark -section headview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headview.backgroundColor=[UIColor clearColor];
    return headview;
}

#pragma mark --sectionview height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1 || section == 2){
        return 10;
    }else
        return 0;
}

#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0){
        BindingAcountVC *bindingAcountVc=[[BindingAcountVC alloc]init];
        [self.navigationController pushViewController:bindingAcountVc animated:YES];
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        RevampPsdVC *revsmppsdVC=[[RevampPsdVC alloc]init];
        [self.navigationController pushViewController:revsmppsdVC animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row == 0){
        InfomationVC *informationVC=[[InfomationVC alloc]init];
        [self.navigationController pushViewController:informationVC animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row ==1){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
           
           NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
           NSLog(@"files :%d",[files count]);
           for (NSString *p in files) {
               NSError *error;
               NSString *path = [cachPath stringByAppendingPathComponent:p];
               if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                   [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
               }
           }
    
       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});

    }
    [self.setingtableview deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -清楚缓存
-(void)clearCacheSuccess
{
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"清理成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
}

#pragma mark --返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag == 1){
        
    }
}

#pragma mark -- 
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
