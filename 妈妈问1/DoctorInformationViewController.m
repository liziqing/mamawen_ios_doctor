//
//  DoctorInformationViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/18.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DoctorInformationViewController.h"
#import "AmendDoctorInformationViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "OutpatientViewController.h"
#import "Hospital.h"

@interface DoctorInformationViewController ()<OutpatientViewControllerDelegate>
{
//-------------------------------------cell title
    NSArray *dataArray1;
    
//------------------------------------------医生头像
    UIImage *headImage;
    AFHTTPRequestOperationManager *manager;
    
//----------------------------------接收个人中心的数据
    NSArray *outpatientArray; //门诊时间
    NSString *doctorNameStr;
    NSString *hospitalStr;
    NSString *departmentStr;
    NSString *titleStr;
    
}
@property(strong,nonatomic)UserInfo *doctor1;
@end

@implementation DoctorInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self dataprocessing];
}


#pragma mark   数据处理
-(void)dataprocessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    dataArray1=@[@[@"",@"姓名",@"医生号",@"收货地址"],@[@"医院",@"科室",@"职称",@"门诊时间"],@[@"擅长",@"背景",@"成就"]];
    
    //----------------------------头像--------
    self.doctor1=[UserInfo sharedUserInfo];
    
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headimage.png"];
    headImage = [[UIImage alloc] initWithContentsOfFile:fullPath];

//-----------------------------网络请求
    manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    self.doctorInformationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight-70) style:UITableViewStylePlain];
    self.doctorInformationTableView.backgroundColor=[UIColor clearColor];
    self.doctorInformationTableView.delegate=self;
    self.doctorInformationTableView.dataSource=self;
    self.doctorInformationTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.doctorInformationTableView.showsVerticalScrollIndicator=NO;
    self.doctorInformationTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:self.doctorInformationTableView];

}

#pragma mark - Table view data source
#pragma mark section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

#pragma mark row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0){
        return 4;
    }else if(section==1){
        return 4;
    }else {
        return 3;
    }
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalTableViewCell2 *personalcell2=[PersonalTableViewCell2 personaltableviewcell2];
    
    static NSString *personal=@"personalMessge";
    UITableViewCell *personalcell = [tableView dequeueReusableCellWithIdentifier:personal];
    if(personalcell==nil){
        personalcell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:personal];
        
    }if(indexPath.section==0 && indexPath.row==0){
        PersonalTableViewCell1 *personalcell1=[PersonalTableViewCell1 PersonalTableViewCell1];
        if(headImage)
            personalcell1.userHeadImage.image=headImage;
       
        return personalcell1;
        
    }else if(indexPath.section==0 && indexPath.row !=0){
        personalcell2.personalcell2Name.text=dataArray1[indexPath.section][indexPath.row];
        
        if(indexPath.row==1){
            personalcell2.personalcellContent.text=self.doctor1.userName;
            
        }else if(indexPath.row==2){
            personalcell2.personalcellContent.text=[NSString stringWithFormat:@"%@",self.doctor1.userID];
            personalcell2.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }else {
            personalcell2.lineView.hidden=YES;
            personalcell2.minImage.hidden=YES;
            
            personalcell2.personalcellContent.text=@"";
        }
        return personalcell2;
        
    }else if(indexPath.section==1){
        personalcell2.personalcell2Name.text=dataArray1[indexPath.section][indexPath.row];
        
        if(indexPath.row==0){
            personalcell2.personalcellContent.text=self.doctor1.userHospital;
            
        }else if(indexPath.row==1){
            personalcell2.personalcellContent.text=self.doctor1.userOffice;
            
        }else if(indexPath.row==2){
            personalcell2.personalcellContent.text=self.doctor1.userZhichen;
            
        }
        if(indexPath.row==3){
            personalcell2.lineView.hidden=YES;
            personalcell2.personalcellContent.text=@"";//user.userServiceTime;
        }
        return personalcell2;
        
    }else if(indexPath.section==2){
        
        personalcell2.personalcell2Name.text=dataArray1[indexPath.section][indexPath.row];
        if(indexPath.row==0){
            if(![self.doctor1.userAdept isEqual:[NSNull null]]){
                    personalcell2.personalcellContent.text=self.doctor1.userAdept;
            }
            
        }else if(indexPath.row==1){
            if(![self.doctor1.userBackgrop isEqual:[NSNull null]]){
                personalcell2.personalcellContent.text=self.doctor1.userBackgrop;
            }
            
        }else{
            personalcell2.lineView.hidden=YES;
            if(![self.doctor1.userAchievement isEqual:[NSNull null]]){
                personalcell2.personalcellContent.text=self.doctor1.userAchievement;
            }
        }
        return personalcell2;
    }else
        return personalcell;
}

#pragma mark   row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row== 0){
        return 60;
    }else
        return 40;
}
#pragma mark   section row
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else
        return 20;
}

#pragma mark sectionView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    sectionview.backgroundColor=[UIColor clearColor];
    return sectionview;
}

#pragma mark select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AmendDoctorInformationViewController *amendInformation=[[AmendDoctorInformationViewController alloc]init];
    
    if(indexPath.section ==0 && indexPath.row == 0){
// --------------------------------------判断是否支持相机
        UIActionSheet *sheet;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            
        }else {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        }
        sheet.tag = 255;
        [sheet showInView:self.view];
        

    }else if((indexPath.section == 0 && (indexPath.row == 1 || indexPath.row==3 )) || (indexPath.section == 2)){
        if(indexPath.section==0 && indexPath.row == 1){
            
            amendInformation.cellInfo = 1;
            if(![self.doctor1.userName isEqual:[NSNull null]]){
                amendInformation.textStr=self.doctor1.userName;
            }
            
        }else if(indexPath.section==0 && indexPath.row == 3){
            amendInformation.cellInfo=3;
            if(![self.doctor1.doctorShouhuoAddress isEqual:[NSNull null]]){
                amendInformation.textStr=self.doctor1.doctorShouhuoAddress;
            }
            
        }else if(indexPath.section == 2 && indexPath.row == 0){
            amendInformation.cellInfo=20;
            if(![self.doctor1.userAdept isEqual:[NSNull null]]){
                amendInformation.textStr=self.doctor1.userAdept;
            }

        }else if(indexPath.section == 2 && indexPath.row == 1){
            amendInformation.cellInfo=21;
            if(![self.doctor1.userBackgrop isEqual:[NSNull null]]){
                amendInformation.textStr=self.doctor1.userBackgrop;
            }
            
        }else if(indexPath.section == 2 && indexPath.row == 2){
            amendInformation.cellInfo=22;
            if(![self.doctor1.userAchievement isEqual:[NSNull null]]){
                amendInformation.textStr=self.doctor1.userAchievement;
            }
            
            
        }
        
        [self.navigationController pushViewController:amendInformation animated:YES];
        
    }else if(indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2)){
        Hospital *hospital=[[Hospital alloc]init];
        if(indexPath.row == 0){
            hospital.hospitalInfo = 0;
            hospital.namecell = self.doctor1.userHospital;
            
        }else if(indexPath.row == 1){
            hospital.hospitalInfo = 1;
            hospital.namecell = self.doctor1.userOffice;
            
            
        }else if(indexPath.row == 2){
            hospital.hospitalInfo = 2;
            hospital.namecell = self.doctor1.userZhichen;
            
        }
        
        
        
        
        
        [self.navigationController pushViewController:hospital animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row == 3){
        OutpatientViewController *outpatientTimeVC=[[OutpatientViewController alloc]init];
        outpatientTimeVC.delegate=self;
        [self.navigationController pushViewController:outpatientTimeVC animated:YES];
        
    }
    [self.doctorInformationTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --门诊时间代理
-(void)transfer:(NSArray *)valueArray{
    outpatientArray = valueArray;
    NSLog(@"outpatientArray--%@",outpatientArray);
    [self upTime];
}


#pragma mark ----选择照片，确定头像
#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//----------------------------------- 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//--------------------------------- 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:image withName:@"headimage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headimage.png"];
    headImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    [self uploadDoctorHeadImage];
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255 || actionSheet.tag ==256) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark 返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
//-------------------提交数据给网络
//        [self tijiaoDataToNetwork];
        
    }
}


//#pragma mark --提交数据到网络
////--------------------------------基本信息
//-(void)tijiaoDataToNetwork{
// 
//    NSDictionary *dict = @{@"name":self.doctor1.userName, @"hospital" :self.doctor1.userHospital,@"department":self.doctor1.userOffice,@"title":self.doctor1.userZhichen};
//    NSString *urlPath=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/information/update?uid=%@&sessionkey=%@",self.doctor1.userID,self.doctor1.sessionKey];
//    [manager POST:urlPath parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
//        NSLog(@"成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"失败");
//    }];

    
//    //-----------------------------网络请求
//    AFHTTPRequestOperationManager *manager1=[AFHTTPRequestOperationManager manager];
//    manager1.responseSerializer=[AFJSONResponseSerializer serializer];
//    manager1.requestSerializer=[AFJSONRequestSerializer serializer];
//    NSDictionary *dict1=@{@"goodAt":self.doctor1.userAdept,@"background":self.doctor1.userBackgrop,@"achievement":self.doctor1.userAchievement,@"serveMore":@(YES)};
//    NSString *urlPath1=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/extra/information/update?uid=%@&sessionkey=%@",self.doctor1.userID,self.doctor1.sessionKey];
//    [manager POST:urlPath1 parameters:dict1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"失败");
//    }];
//}


#pragma mark  更新门诊时间
-(void)upTime{
    NSString *urlPath=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/worktime/update?uid=%i&sessionkey=%i",[self.doctor1.userID integerValue] ,123];
    
    [manager POST:urlPath parameters:outpatientArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject--%@",(NSDictionary *)responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}


#pragma mark --网络上传医生头像
-(void)uploadDoctorHeadImage{

    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5f);
    
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/avatar/upload?uid=%i&sessionkey=%i",[self.doctor1.userID intValue],123];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"plate.png" mimeType:@"savedImage/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject != nil){
            NSDictionary *dictionary=(NSDictionary *)responseObject;
            if([[dictionary objectForKey:@"code"]integerValue]==0){
                NSLog(@"%@",responseObject);
                NSDictionary *dict=(NSDictionary *)responseObject;
                
                self.doctor1.userHeadimage=[[dict objectForKey:@"doctor"] objectForKey:@"avatar"];
                
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@", error);
    }];

}





-(void)viewWillAppear:(BOOL)animated{
    
    self.doctor1=[UserInfo sharedUserInfo];
    [self.doctorInformationTableView reloadData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
