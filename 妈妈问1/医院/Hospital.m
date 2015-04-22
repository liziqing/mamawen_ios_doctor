//
//  Hospital.m
//  妈妈问1
//
//  Created by alex on 15/4/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "Hospital.h"
#import "BackView.h"
#import "AllData.h"
#import "UserInfo.h"
#import "AFNetworking.h"

@interface Hospital ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *hospitalNameArray;
}

@property(strong,nonatomic)UITableView *hospitalTableVC;
@property(strong,nonatomic)UserInfo *doctor;
@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;

@end

@implementation Hospital

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
}

#pragma mark -- 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
    [self.view sendSubviewToBack:backview];
    
//----------数据
    if(self.hospitalInfo == 0){
        self.mytitleLable.text=@"医院列表";
        AllData *allData=[[AllData alloc]init];
        hospitalNameArray=allData.hospitalArray;
        
    }else if(self.hospitalInfo == 1){
        self.mytitleLable.text=@"科室列表";
        hospitalNameArray = @[@"儿科",@"产科",@"妇科"];
        
        
    }else if(self.hospitalInfo == 2){
        self.mytitleLable.text = @"职称列表";
        hospitalNameArray =@[@"主任医师",@"医师",@"执业医师"];
        
    }
    self.doctor=[UserInfo sharedUserInfo];
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    self.hospitalTableVC = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.hospitalTableVC.dataSource=self;
    self.hospitalTableVC.delegate=self;
    self.hospitalTableVC.tableFooterView=[[UIView alloc]init];
    self.hospitalTableVC.showsVerticalScrollIndicator=NO;
    self.hospitalTableVC.backgroundColor=[UIColor clearColor];
    self.hospitalTableVC.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.hospitalTableVC];
    

    
    
}

#pragma mark --- tableview 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return hospitalNameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *info=@"hospital";
    UITableViewCell *mycell=[tableView dequeueReusableCellWithIdentifier:info];
    if(mycell == nil){
        mycell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:info];
    }
    if(self.hospitalInfo == 0){
        mycell.textLabel.text=[hospitalNameArray[indexPath.row] objectForKey:@"name"];

    }else if(self.hospitalInfo == 1){
        mycell.textLabel.text = hospitalNameArray[indexPath.row];
        
    }else if(self.hospitalInfo == 2){
         mycell.textLabel.text = hospitalNameArray[indexPath.row];
    }
    
    
    mycell.textLabel.textColor=[UIColor whiteColor];
    mycell.textLabel.font=[UIFont systemFontOfSize:13.0];
    mycell.textLabel.numberOfLines=1;
    CGSize size1=CGSizeMake(kScreenWidth, 44);
    CGSize size2 = [mycell.textLabel sizeThatFits:size1];
    mycell.textLabel.frame = CGRectMake(0, 0, size2.width, size2.height);
    
    if(self.hospitalInfo == 0){
        for(NSInteger i =0 ; i<hospitalNameArray.count; i++){
            if([self.namecell isEqualToString:[hospitalNameArray[i] objectForKey:@"name"]] && [[hospitalNameArray[i]objectForKey:@"name"] isEqualToString:[hospitalNameArray[indexPath.row] objectForKey:@"name"]]){
                UIImageView *selectimage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mycell.textLabel.frame)+20, 5, 20, 20)];
                selectimage.backgroundColor=[UIColor redColor];
                [mycell.contentView addSubview:selectimage];
            }
        }
    }else if(self.hospitalInfo == 1){
        for(NSInteger i =0 ; i<hospitalNameArray.count; i++){
            if([self.namecell isEqualToString:hospitalNameArray[i]] && [hospitalNameArray[i] isEqualToString:hospitalNameArray[ indexPath.row]]){
                UIImageView *selectimage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mycell.textLabel.frame)+20, 5, 20, 20)];
                selectimage.backgroundColor=[UIColor redColor];
                [mycell.contentView addSubview:selectimage];
            }
        }
    }else if(self.hospitalInfo == 2){
        for(NSInteger i =0 ; i<hospitalNameArray.count; i++){
            if([self.namecell isEqualToString:hospitalNameArray[i]] && [hospitalNameArray[i] isEqualToString:hospitalNameArray[ indexPath.row]]){
                UIImageView *selectimage=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(mycell.textLabel.frame)+20, 5, 20, 20)];
                selectimage.backgroundColor=[UIColor redColor];
                [mycell.contentView addSubview:selectimage];
            }
        }
    }
    
    mycell.backgroundColor=[UIColor clearColor];
    return mycell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.hospitalInfo == 0){
        self.doctor.userHospital = [hospitalNameArray[indexPath.row] objectForKey:@"name"];
        
    }else if(self.hospitalInfo == 1){
        self.doctor.userOffice =hospitalNameArray[indexPath.row];
        
    }else if(self.hospitalInfo == 2){
        self.doctor.userZhichen = hospitalNameArray[indexPath.row];
    }
    
    [self networking];
}

#pragma mark -- 网络
-(void)networking{
        NSDictionary *dict = @{@"name":self.doctor.userName, @"hospital" :self.doctor.userHospital,@"department":self.doctor.userOffice,@"title":self.doctor.userZhichen};
    
        NSString *urlPath=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/information/update?uid=%@&sessionkey=%@",self.doctor.userID,self.doctor.sessionKey];
    
        [_manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
            NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
            [self.navigationController popViewControllerAnimated:YES];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"失败");
        }];
}


#pragma mark --- 返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
