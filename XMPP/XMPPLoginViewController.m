//
//  ViewController.m
//  chatdemo
//
//  Created by lixuan on 15/2/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "XMPPLoginViewController.h"
#import "LXXMPPManager.h"
#import "FriendListViewController.h"
#import "UserInfo.h"

@implementation XMPPLoginViewController

- (void)userNameAndPassword {
    
    if (!_myJid || !_password) {
        UserInfo *user = [UserInfo sharedUserInfo];
        _myJid = [NSString stringWithFormat:@"%@@182.254.222.156",user.jid];
        _password = user.passWord;
}
        
  
}
- (void)loginOpenfire {
#warning 修改密码/退出登录    设置‘0’
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"hasLoginOnce"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self userNameAndPassword];
    [self registerAction];
    [self loginAction];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self uiConfig];
}
- (void)uiConfig {
    [self userNameAndPassword];
}

- (void)registerAction {
    // 注册 -- 初始化
    [[LXXMPPManager shareXMPPManager]
     registerUser:_myJid
     withPassword:_password
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"注册成功");
         }
         else {
             NSLog(@"注册失败 error = %@",error);
         }
     }];
}
- (void)loginAction {
    NSLog(@"jid is %@",_myJid);
    [[LXXMPPManager shareXMPPManager]
     loginUser:_myJid
     withPassword:_password
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"登陆成功!!!");
//             FriendListViewController *fvc = [[FriendListViewController alloc] init];
//             UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:fvc];
//             [self presentViewController:navi animated:YES completion:nil];
         }
         else {
             NSLog(@"登陆失败 error = %@",error);
         }
     }];

}

+ (void)reconnect {
    
    UserInfo *user = [UserInfo sharedUserInfo];
    NSString *jid = [NSString stringWithFormat:@"%@@182.254.222.156",user.jid];
    NSString *pwd = @"123456";
    
    
    [[LXXMPPManager shareXMPPManager]
     loginUser:jid
     withPassword:pwd
     withCompletion:^(BOOL ret, NSError *error) {
         if (YES == ret) {
             NSLog(@"reconnect成功!!!");
             //             FriendListViewController *fvc = [[FriendListViewController alloc] init];
             //             UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:fvc];
             //             [self presentViewController:navi animated:YES completion:nil];
         }
         else {
             NSLog(@"reconnect失败 error = %@",error);
         }
     }];
    
    XMPPJID *myJID = [XMPPJID jidWithString:jid];
    
    //    if ([_xmppStream isConnecting]) {
    //        [_xmppStream disconnect];
    //    }
    //    [_xmppStream setMyJID:myJID];
    ////    NSError *err = nil;
    //    BOOL ret = [_xmppStream connectWithTimeout:-1 error:&err];
    
    
}
- (void)offLine {
    [[LXXMPPManager shareXMPPManager] offlineWithXMPP];
}

+ (void)loginOpenfire {
    XMPPLoginViewController *vc = [[XMPPLoginViewController alloc] init];
    [vc loginOpenfire];
}
+ (void)offLine {
    XMPPLoginViewController *vc = [[XMPPLoginViewController alloc] init];
    [vc offLine];
}
- (IBAction)registerClick:(UIButton *)sender {
    [self registerAction];
}


- (IBAction)loginClick:(UIButton *)sender {
    [self loginAction];
}
@end
/*
 - (NSUInteger)DaysAgainstDate:(NSString*)againstDate
 {
 NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
 [mdf setDateFormat:@"yyyyMMdd"];
 NSDate *againstMidnightDate = [mdf dateFromString:againstDate];
 NSTimeInterval difftime = [againstMidnightDate timeIntervalSinceNow];
 ／／与今天的时间差
 difftime = (-difftime) / (60*60*24);
 
 return difftime;
 }
 */