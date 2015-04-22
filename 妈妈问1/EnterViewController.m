//
//  EnterViewController.m
//  妈妈问1
//
//  Created by netshow on 15/2/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "EnterViewController.h"
#import "NSString+psd.h"
#import "ForgetPSDViewController.h"
#import "AppDelegate.h"


#import "LXXMPPManager.h"
#import "XMPPLoginViewController.h"


//static EnterViewController *envc;

@interface EnterViewController ()
{
//----------------------------头像数据
    NSMutableData *_headData;
    UIImage *headImaga;
    
    BackView *back;

//------个推CID
    AppDelegate *delegate;
    NSString *clientID1;
}


@end

@implementation EnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self backIcon];//返回按钮样式方法
    [self editingText];//文本编辑
    
    [self dataprosessing];
    
}


//+(EnterViewController *)EnterViewController{
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        envc = [[EnterViewController alloc] init];
//    });
//    return envc;
//    
//}



#pragma mark 杂乱数据
-(void)dataprosessing{
    self.navigationController.interactivePopGestureRecognizer.enabled=NO;//取消自带的返回效果
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    clientID1 = [delegate testGetClientId];
    
    self.doctorHeadImage.layer.cornerRadius=30;
    self.doctorHeadImage.layer.masksToBounds=YES;
    
    self.finishBtn.layer.cornerRadius = kBtnCornerRadius;
    self.finishBtn.layer.masksToBounds = YES;
 
#pragma mark------医院列表
//    NSString *path=[[NSBundle mainBundle]pathForResource:@"hospitalDatasource" ofType:@"plist"];
//    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:path];
    
//-----------------给标签添加手势
    [self addTapGR:self.forgetPsd];
    [self addTapGR:self.registerIcon];
    
//------------------------------- 背景色
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
    [self.view sendSubviewToBack:backview];
}


#pragma mark 文本编辑
-(void)editingText{
    self.poneNunberPsd.secureTextEntry=YES;
    self.poneNunberText.clearButtonMode=UITextFieldViewModeUnlessEditing;
    self.poneNunberPsd.clearButtonMode=UITextFieldViewModeUnlessEditing;
}


#pragma mark 忘记密码和 用户注册手势
-(void)addTapGR:(UILabel *)myLable{
    UITapGestureRecognizer *mytapLable=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLable:)];
    [myLable addGestureRecognizer:mytapLable];
    [myLable setUserInteractionEnabled:YES];
}

#pragma mark --手势方法
-(void)tapLable:(UITapGestureRecognizer *)param{
    
    UILabel *lableInfo=(UILabel *)[param view];
    if(lableInfo.tag == 0){
        ForgetPSDViewController *forgetpsdVC=[[ForgetPSDViewController alloc]init];
        [self.navigationController pushViewController:forgetpsdVC animated:YES];
        
    }else if(lableInfo.tag==1){
        RegisterViewController *registerView=[[RegisterViewController alloc]init];
        [self.navigationController pushViewController:registerView animated:YES];
    }else{
        
    }
}
#pragma mark 返回按钮样式
-(void)backIcon
{
    UIBarButtonItem *Backbutton=[[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem=Backbutton;
    self.title=@"";
}


#pragma mark 结束文本编辑
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.poneNunberText endEditing:YES];
    [self.poneNunberPsd endEditing:YES];
}

#pragma mark --登陆按钮事件
- (IBAction)enterAction:(UIButton *)sender {
    if(self.poneNunberText.text.length==0 || self.poneNunberPsd.text.length==0){
        [[[UIAlertView alloc]initWithTitle:@"消息提示" message:@"您输入的用户名或密码为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        
    }else
        [self doctorNameEnter];//判断医生登入
    
  }

#pragma mark 登入向网络请求医生用户数据
-(void)doctorNameEnter{
    
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"phoneNumber": self.poneNunberText.text, @"password" :[[self.poneNunberPsd.text sha256Encrypt] base64Encrypt]/*,@"deviceType":@(1),@"deviceToken":self.user.deviceToken*/};
    
    [manager POST:@"http://115.159.49.31:9000/doctor/login" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
       NSLog(@"------%@******", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSDictionary *doctorDiction=(NSDictionary *)responseObject;
        if([[doctorDiction objectForKey:@"code"]integerValue]==0){
            //医生信息
            NSDictionary *doctorInformationDiction=[doctorDiction objectForKey:@"doctor"];
   
//-----------------------------医生头像
            self.user.userHeadimage=[doctorInformationDiction objectForKey:@"avatar"];
            self.user.userName=[doctorInformationDiction objectForKey:@"name"];
            self.user.userTelephone=[doctorInformationDiction objectForKey:@"cellPhone"];
            self.user.userID=[doctorInformationDiction objectForKey:@"doctorID"];
            self.user.userlevel=[doctorInformationDiction objectForKey:@"level"];
            
            self.user.userHospital=[doctorInformationDiction objectForKey:@"hospital"];
            self.user.userOffice=[doctorInformationDiction objectForKey:@"department"];
            self.user.userZhichen=[doctorInformationDiction objectForKey:@"title"];
           // self.user.userServiceTime=[doctorInformationDiction objectForKey:@""];
            
            self.user.userAdept=[doctorInformationDiction objectForKey:@"goodAt"];
            self.user.userBackgrop=[doctorInformationDiction objectForKey:@"background"];
            self.user.userAchievement=[doctorInformationDiction objectForKey:@"achievement"];
            
            self.user.plateUrl=[doctorInformationDiction objectForKey:@"plateUrl"];
            self.user.jid=[doctorInformationDiction objectForKey:@"jid"];
            self.user.imToken=[doctorInformationDiction objectForKey:@"imToken"];
            self.user.sessionKey=[doctorInformationDiction objectForKey:@"sessionKey"];
            
            self.user.userID=[doctorInformationDiction objectForKey:@"doctorID"];
            self.user.userNickName=[doctorInformationDiction objectForKey:@"userName"];
            self.user.userAchievement=[doctorInformationDiction objectForKey:@"achievement"];
            self.user.passWord =[[self.poneNunberPsd.text sha256Encrypt] base64Encrypt] ;
            
//------------------------  he ----------------------------
            // 登陆IM
            XMPPLoginViewController *vc = [[XMPPLoginViewController alloc] init];
            vc.myJid = [self.user.jid  stringByAppendingString:  @"@182.254.222.156"];
            vc.password = @"123456";
            [vc loginOpenfire];
//------------------------  he  --------------------------
            
            if(![self.user.userHeadimage isEqual:[NSNull null]]){
                _headData = [NSMutableData data];
                NSString *headimagepath=[NSString stringWithFormat:@"http://115.159.49.31:9000%@",self.user.userHeadimage];
                NSURL *url = [NSURL URLWithString:headimagepath];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:self];
                [con start];
            }
            
            _tabBarVier=[TabBarViewController sharetablevc];
            
            [self.navigationController pushViewController:_tabBarVier animated:YES];

        }else{
            [[[UIAlertView alloc]initWithTitle:@"消息提示" message:@"您输入的用户名或密码错误1" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
        }
        
        
    
        
        NSString *urlstr=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/clientID/bind?uid=%@&sessionkey=%@",self.user.userID,self.user.sessionKey];
        NSDictionary *dict=@{@"clientID":clientID1};
        
        [manager POST:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"errror--%@",error);
        }];
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[[UIAlertView alloc]initWithTitle:@"消息提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show];
    }];
}

//------------------------头像------------------------------4
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_headData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    headImaga = [UIImage imageWithData:_headData];
    [self saveImage:headImaga withName:@"headimage.png"];
    _headData = nil;
    
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
//------------------- 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    NSLog(@"----%@",fullPath);
//----------------------- 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}


#pragma mark 消失本view的navigationBar
-(void)viewWillAppear:(BOOL)animated
{
    self.user=[UserInfo sharedUserInfo];
    self.navigationController.navigationBar.hidden=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
