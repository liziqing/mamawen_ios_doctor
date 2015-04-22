//
//  UserInfo.h
//  妈妈问1
//
//  Created by netshow on 15/3/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserEnterDelegate <NSObject>

@optional


@end

@interface UserInfo : NSObject

  //用户信息属性
@property(strong,atomic)NSString *userID;          //ID
@property(strong,atomic)NSString *sessionKey;
@property(strong,atomic)NSString *jid;
@property(strong,atomic)NSString *imToken;
@property(strong,atomic)NSString *plateUrl;      //

@property(strong,atomic)NSString *userHeadimage;   //头像
@property(strong,atomic)NSString *userName;        //真名
@property(strong,atomic)NSString *userNickName;     //昵称
@property(strong,atomic)NSString *doctorShouhuoAddress;     //地址

@property(strong,atomic)NSString *userTelephone;   //电话
@property(strong,atomic)NSString *userEmail;       //邮箱

@property(strong,atomic)NSString *userHospital;    //医院
@property(strong,atomic)NSString *userOffice;      //科室
@property(strong,atomic)NSString *userZhichen;      //职称
@property(strong,atomic)NSString *userServiceTime;  //问诊时间

@property(strong,atomic)NSString *userAdept;        //擅长
@property(strong,atomic)NSString *userBackgrop;    //背景
@property(strong,atomic)NSString *userAchievement;   //成就

@property(strong,atomic)NSString *userlevel;       //级别
@property(strong,nonatomic)NSString *passWord;

@property (nonatomic, copy)  NSString *deviceToken;
@property(assign,nonatomic)id<UserEnterDelegate>deledate;

//单例实例化
+ (UserInfo *)sharedUserInfo;

//判断是否登录
+ (BOOL)isEnter;

//退出登录
+ (void)quitEnter;

//登录
- (void)startEnter:(NSDictionary *)login;

//用词典初始化
- (void)userInfoWithDictionary:(NSDictionary *)userInfo;

@end
