//
//  UserInfo.m
//  妈妈问1
//
//  Created by netshow on 15/3/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

static UserInfo *_user;

#pragma mark 单例实例化
+ (UserInfo *)sharedUserInfo {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _user = [[UserInfo alloc] init];
    });
    return _user;
}

#pragma mark  判断是否登录
+ (BOOL)isEnter{
    return 0!=_user.userID.length;
}

#pragma mark  退出登录
+ (void)quitEnter{
    
}

#pragma mark  登录
- (void)startEnter:(NSDictionary *)login{
    
}

#pragma mark  用词典初始化
- (void)userInfoWithDictionary:(NSDictionary *)userInfo{
    
}
@end
