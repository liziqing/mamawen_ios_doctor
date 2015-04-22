//
//  AddPatientViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AddPatientViewController.h"
#import "BackView.h"
#import "UserInfo.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"
#import "TelephoneViewController.h"


@interface AddPatientViewController ()

{

}
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation AddPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataprocessing];
}

#pragma mark 数据
-(void)dataprocessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];

//--------------设置控件的圆角属性
    self.doctorHeadImage.layer.cornerRadius=30;
    self.doctorHeadImage.layer.masksToBounds=YES;
    self.phoneIcon.layer.cornerRadius=3;
    self.phoneIcon.layer.masksToBounds=YES;
    
    self.doctor=[UserInfo sharedUserInfo];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"headimage.png"];
    NSLog(@"---%@",fullPath);
    self.doctorHeadImage.image = [[UIImage alloc] initWithContentsOfFile:fullPath];

//--------------------------------医生昵称
    UILabel *doctorNameLable=[[UILabel alloc]initWithFrame:CGRectMake(100, 90, 40, 20)];
    doctorNameLable.text=self.doctor.userName;
    doctorNameLable.textColor=[UIColor whiteColor];
    doctorNameLable.font=[UIFont systemFontOfSize:13.0];
    doctorNameLable.numberOfLines=0;
    CGSize size1=CGSizeMake(kScreenWidth-120, 20);
    CGSize size2=[doctorNameLable sizeThatFits:size1];
    doctorNameLable.frame=CGRectMake(100, 90, size2.width, size2.height);
    [self.view addSubview:doctorNameLable];
    
//------------------------------医生职称
    UILabel *doctorZhichenLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(doctorNameLable.frame)+10, 90, 90, 20)];
    doctorZhichenLable.textColor=[UIColor whiteColor];
    doctorZhichenLable.text=self.doctor.userZhichen;
    doctorZhichenLable.font=[UIFont systemFontOfSize:13.0f];
    doctorZhichenLable.numberOfLines=1;
    CGSize size3=CGSizeMake(kScreenWidth-CGRectGetMaxX(doctorNameLable.frame), 20);
    CGSize size4=[doctorZhichenLable sizeThatFits:size3];
    doctorZhichenLable.frame=CGRectMake(CGRectGetMaxX(doctorNameLable.frame)+10, 90, size4.width, size4.height);
    [self.view addSubview:doctorZhichenLable];
    
//-----------------------医院名称
    UILabel *doctorHospitalLable=[[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(doctorNameLable.frame)+10, 80, 20)];
    doctorHospitalLable.text=self.doctor.userHospital;
    doctorHospitalLable.textColor=[UIColor whiteColor];
    doctorHospitalLable.font=[UIFont systemFontOfSize:13.0f];
    doctorHospitalLable.numberOfLines=2;
    CGSize size5=CGSizeMake(kScreenWidth-120, 40);
    CGSize size6=[doctorHospitalLable sizeThatFits:size5];
    doctorHospitalLable.frame=CGRectMake(100, CGRectGetMaxY(doctorNameLable.frame)+10, size6.width, size6.height);
    [self.view addSubview:doctorHospitalLable];
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(doctorNameLable.frame)+5, size6.width, 1)];
    lineview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:lineview];
  
   
//--------------------------------二维码-------------------------

    NSString *str=[NSString stringWithFormat:@"%@",self.doctor.userID];
    _imageview.image = [QRCodeGenerator qrImageForString:str imageSize:_imageview.bounds.size.width];
}

#pragma mark  二维码代理
//- (void) readerView: (ZBarReaderView*) readerView didReadSymbols: (ZBarSymbolSet*) symbols fromImage: (UIImage*) image{
//    
//}

//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    id<NSFastEnumeration> results =[info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        break;
//    
//    _imageview.image =[info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    [reader dismissModalViewControllerAnimated: YES];
//    
//    //判断是否包含 头'http:'
//    NSString *regex = @"http+:[^\\s]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    
//    //判断是否包含 头'ssid:'
//    NSString *ssid = @"ssid+:[^\\s]*";;
//    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
//    
//
//    
//    if ([predicate evaluateWithObject:label.text]) {
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
//                                                        message:@"It will use the browser to this URL。"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Close"
//                                              otherButtonTitles:@"Ok", nil];
//        alert.delegate = self;
//        alert.tag=1;
//        [alert show];
//        [alert release];
//        
//        
//        
//    }
//    else if([ssidPre evaluateWithObject:label.text]){
//        
//        NSArray *arr = [label.text componentsSeparatedByString:@";"];
//        
//        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
//        
//        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
//        
//        
//        label.text=
//        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
//         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
//        
//        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:label.text
//                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Close"
//                                              otherButtonTitles:@"Ok", nil];
//        
//        
//        alert.delegate = self;
//        alert.tag=2;
//        [alert show];
//        [alert release];
//        
//        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
//        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
//        pasteboard.string = [arrInfoFoot objectAtIndex:1];
//        
//        
//    }
//}



#pragma mark 返回，添加患者事件
- (IBAction)backBtn:(UIButton *)sender {
    if(sender.tag == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }else if(sender.tag == 1){
        TelephoneViewController *telephoneView=[[TelephoneViewController alloc]init];
        [self.navigationController pushViewController:telephoneView animated:YES];


    }
}

#pragma mark 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=YES;
    
     self.doctor=[UserInfo sharedUserInfo];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
