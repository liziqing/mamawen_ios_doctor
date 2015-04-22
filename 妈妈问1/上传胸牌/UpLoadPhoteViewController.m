//
//  UpLoadPhoteViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "UpLoadPhoteViewController.h"
#import "BackView.h"
#import "AFNetworking.h"
#import "UserInfo.h"

@interface UpLoadPhoteViewController ()
{
//--------------------------工牌照片
    UIImage *savedImage;
    UIImage *savedImage1;
    NSString *fullPath;

//---------------确定按钮标识
    UIButton *btn1;
    UIButton *btn2;
    int BtnInfo;
}
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation UpLoadPhoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataProcessing];
    
    [self addTapGR:self.imageview];
}

#pragma mark 杂乱数据
-(void)dataProcessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.backBtn.layer.cornerRadius=3;
    self.backBtn.layer.masksToBounds=YES;
    
    UIImageView *ima=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    ima.backgroundColor=[UIColor whiteColor];
    ima.alpha=0.3;
    ima.userInteractionEnabled=YES;
    [self.gongpaiview addSubview:ima];
    
    btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.tag=1;
    btn1.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    btn1.frame=CGRectMake(0, 0, kScreenWidth/2, 40);
    [btn1 setTitle:@"普通认证" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.gongpaiview addSubview:btn1];
    
    btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.tag=2;
    btn2.backgroundColor=[UIColor clearColor];
    btn2.frame=CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 40);
    [btn2 setTitle:@"权威认证" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.gongpaiview addSubview:btn2];
    
    self.doctor=[UserInfo sharedUserInfo];
    BtnInfo=2;
    
    fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    if([[UIImage alloc] initWithContentsOfFile:fullPath] != nil){
        self.jiaimage.hidden=YES;
        self.imageview.alpha=1;
        self.imageview.image=[[UIImage alloc] initWithContentsOfFile:fullPath];

    }
        
}

#pragma mark --认证按钮事件
-(void)actionBtn:(UIButton *)sender{
    if(sender.tag == 1){
        btn1.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
        btn2.backgroundColor=[UIColor clearColor];
        BtnInfo=2;
        self.mylable1.text=@"上传胸牌";
        self.mylable2.text=@"请保证姓名,医院,职称等信息清晰可辨";
        self.mylable3.text=@"图片仅用于认证,第三方无法获取";
        self.mylable4.text=@"完成普通认证后,将允许你在线接诊";
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *image2=[[UIImage alloc] initWithContentsOfFile:fullPath];
        if(image2 == nil){
            self.imageview.alpha=0.5;
            self.imageview.image=nil;
            self.jiaimage.hidden=NO;
        }else{
            self.jiaimage.hidden=YES;
            self.imageview.alpha=1;
            self.imageview.image=[[UIImage alloc] initWithContentsOfFile:fullPath];
        }
        
    }else{
        btn1.backgroundColor=[UIColor clearColor];
        btn2.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
        BtnInfo=3;
        self.mylable1.text=@"上传资格证或执业证";
        self.mylable2.text=@"请确保证书上姓名,医院,编号,执业范围等信息";
        self.mylable3.text=@"上传资料仅用于认证,患者及第三方不可见";
        self.mylable4.text=@"完成权威认证后,即可开启付费模式";
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage1.png"];
        UIImage *image1=[[UIImage alloc] initWithContentsOfFile:fullPath];
        
        if(image1 == nil ){
            self.imageview.alpha=0.5;
            self.imageview.image=nil;
            self.jiaimage.hidden=NO;
            
        }else{
            self.jiaimage.hidden=YES;
            self.imageview.alpha=1;
            self.imageview.image=[[UIImage alloc] initWithContentsOfFile:fullPath];
        }

    }
    
}




#pragma mark  工牌手势
-(void)addTapGR:(UIImageView *)gongpaiImage{
    UITapGestureRecognizer *recogniaer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGongpaishoushi:)];
    [gongpaiImage addGestureRecognizer:recogniaer];
    gongpaiImage.userInteractionEnabled=YES;
}

-(void)tapGongpaishoushi:(UITapGestureRecognizer *)parm{
    UIImageView *imageview1=(UIImageView *)[parm view];
    if(imageview1.tag == 0){
        if(BtnInfo == 2){
//----------------------------------- 判断是否支持相机    
            UIActionSheet *sheet;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            }else {
                
                sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            }
            sheet.tag = 255;
            [sheet showInView:self.view];
            
        }else if(BtnInfo == 3){

            UIActionSheet *sheet1;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                sheet1 = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
            }else {
                
                sheet1 = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
            }
            sheet1.tag = 256;
            [sheet1 showInView:self.view];
            
        }
    }
}


#pragma mark 返回，完成 选择图片按钮事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(sender.tag == 1){
        if(self.imageview.image == nil){
           [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传牌照" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        }else
            [self xiongpai];
        
    }
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
// 获取沙盒目录
    fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"----%@",fullPath);
// 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if(BtnInfo==2){
        [self saveImage:image withName:@"currentImage.png"];
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        
        self.jiaimage.hidden=YES;
        self.imageview.alpha=1;
         [self.imageview setImage:savedImage];
        
    }else if(BtnInfo==3){
        [self saveImage:image withName:@"currentImage1.png"];
        
        fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage1.png"];
        savedImage1 = [[UIImage alloc] initWithContentsOfFile:fullPath];
        self.jiaimage.hidden=YES;
        self.imageview.alpha=1;
        
        [self.imageview setImage:savedImage1];
        
    }
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



#pragma mark ----网络请求图片
-(void)xiongpai {
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSData *imageData = UIImageJPEGRepresentation(savedImage, 0.5f);
    NSData *imageData1=UIImageJPEGRepresentation(savedImage1, 0.5f);
    
    NSString *urlStr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/level/authen?uid=%i&sessionkey=%i",[self.doctor.userID intValue],123];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(imageData != nil){
            [formData appendPartWithFileData:imageData name:@"plate" fileName:@"plate.png" mimeType:@"image/png"];
        }else if(imageData1 != nil){
            [formData appendPartWithFileData:imageData1 name:@"license" fileName:@"license.png" mimeType:@"image/png"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(responseObject != nil){
            NSLog(@"---%@",responseObject);
            NSDictionary *dictionary=(NSDictionary *)responseObject;
            if([[dictionary objectForKey:@"code"]integerValue]==0){
                NSDictionary *dic=(NSDictionary *)responseObject;
                
                self.doctor.userlevel=[[dic objectForKey:@"doctor"] objectForKey:@"level"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败%@", error);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
