//
//  Constant.h
//  妈妈问1
//
//  Created by netshow on 15/2/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#ifndef ___1_Constant_h
#define ___1_Constant_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight self.navigationController.navigationBar.bounds.size.height
#define kNavigationBarWidth self.navigationController.navigationBar.bounds.size.width
#define kNowDate [NSDate date]
#define kTabBarHeight self.tabBarController.tabBar.bounds.size.height

//------------------按钮边角值
#define kBtnCornerRadius 3
#define kUrlPath @"http://115.159.49.31:9000"

//------he-----
#define kMessageFormUser     @"kMessageFormUser"
#define kMessageToUser       @"kMessageToUser"

#define iphone6 [UIScreen mainScreen].bounds.size.height > 600
#define kReceiveMessageNotification @"kReceiveMessageNotification"

#define kDeviceToken                 @"kDeviceToken"

typedef NS_ENUM(NSInteger, chatMode)  { // 聊天类型
    chatModeNone = 0,
    chatModeString,
    chatModePicture,
    chatModeVideo,
    
};
typedef NS_ENUM (NSInteger, chatRole) {// 信息角色
    chatRoleDoctor = 0,
    chatRolePatient,
};
typedef NS_ENUM (NSInteger, chatCatagory) { // 信息分类
    chatCatagoryNormal = 1,
    chatCatagoryAdmissions,
    chatCatagoryPrediagnosisReport,
    chatCatagoryFindDr
};
//--------he-----
#endif
