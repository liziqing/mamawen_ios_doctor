//
//  AppDelegate.m
//  妈妈问1
//
//  Created by netshow on 15/2/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"
#import "XMPPLoginViewController.h"

@interface AppDelegate ()
{
   
}

@end

//--------个推
#define kAppId           @"gezPgAzgQ4A2LuzdyApzZ8"
#define kAppKey          @"OJ7QnLmGrh8vC2aC7aCO39"
#define kAppSecret       @"aKp82883ka5qiUs09mW3M7"



@implementation AppDelegate

#pragma mark  --出现
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
    
    
    
    
    
#pragma mark-----个推--- [1]:使用APPID/APPKEY/APPSECRENT创建个推实例 -----
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];   //---初始化

    [self registerRemoteNotification];
    
#pragma mark----- [2-EXT]: 获取启动时收到的APN
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

#pragma mark--------个推------- 接收远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
    //    [_viewController logMsg:record];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
//    [_viewController logMsg:record];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
//-----------------------

#pragma mark--- 远程通知注册成功----[3]:向个推服务器注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

//    token = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *token1 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UserInfo *user = [UserInfo sharedUserInfo];
    user.deviceToken = token;
    

    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:token];
    }
}

#pragma mark--------个推----[3-EXT]:如果APNS注册失败，通知个推服务器
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{

    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }

}

#pragma mark-----个推---- 注册APNS
- (void)registerRemoteNotification {

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
    } else {
        
        UIRemoteNotificationType type = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
   [XMPPLoginViewController offLine];
}

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
#pragma mark-----个推----[EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
//    [self stopSdk];
    [XMPPLoginViewController offLine];
}

// 将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

#pragma mark ----个推---[EXT] 重新上线
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];

}

- (void)applicationWillTerminate:(UIApplication *)application {
   [XMPPLoginViewController offLine];
}


#pragma mark  1-----创建个推实例
- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID appKey:_appKey appSecret:_appSecret appVersion:@"0.0.0" delegate:self error:&err];
    }
}

#pragma mark  ----调用个推----
- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        _sdkStatus = SdkStatusStoped;
        _clientId = nil;

    }
}


#pragma mark -------个推-----
- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}


#pragma mark-----个推----
- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

#pragma mark-----个推----
- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

#pragma mark-----个推----消息
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    return [_gexinPusher sendMessage:body error:error];
}

#pragma mark-----个推----
- (void)bindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher bindAlias:aAlias];
}

#pragma mark-----个推----
- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [_gexinPusher unbindAlias:aAlias];
}


#pragma mark-----个推----获取CID
- (NSString *)testGetClientId {
    NSString *clientId = [_gexinPusher clientId];
    return clientId;
}

#pragma mark ----个推代理----[4-EXT-1]: 个推SDK已注册
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    _sdkStatus = SdkStatusStarted;

}

#pragma mark ----个推---[2]: 收到个推消息
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
     NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
       
    }
}

#pragma mark ----个推---[3-EXT]:发送上行消息结果反馈
- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {

}


#pragma mark ----个推---[4 EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
- (void)GexinSdkDidOccurError:(NSError *)error
{

}


@end
