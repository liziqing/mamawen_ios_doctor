//
//  UserModel.h
//  chatdemo
//
//  Created by lixuan on 15/2/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *jid; // 用户名  xmpp中称为 jid  （jabber id）
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *status;

- (BOOL)isOnline;
@end
