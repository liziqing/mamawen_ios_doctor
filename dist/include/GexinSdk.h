//
//  GexinSdk.h
//  GexinSdk
//
//  Created by user on 11-12-28.
//  Copyright (c) 2011年 Gexin Interactive (Beijing) Network Technology Co.,LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXSdkError.h"

@protocol GexinSdkDelegate;

@interface GexinSdk : NSObject {
@private
    void *_impl;
}

+ (NSString *)version;

+ (void)setAllowedRotateUiOrientations:(NSArray *)orientations;

+ (GexinSdk *)createSdkWithAppId:(NSString *)appid appKey:(NSString *)appKey appSecret:(NSString *)appSecret 
                      appVersion:(NSString *)aAppVersion
                       delegate:(id<GexinSdkDelegate>)delegate
                          error:(NSError **)error;

- (NSData *)retrivePayloadById:(NSString *)payloadId;

- (void)registerDeviceToken:(NSString *)deviceToken;
- (BOOL)setTags:(NSArray *)tags;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;
- (void)destroy;
- (NSString *)clientId;

- (void)bindAlias:(NSString *)alias;
- (void)unbindAlias:(NSString *)alias;

@end

@protocol GexinSdkDelegate <NSObject>
@optional
- (void)GexinSdkDidRegisterClient:(NSString *)clientId;  //注册个推
- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId; //收到消息
- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result;   //结果反馈
- (void)GexinSdkDidOccurError:(NSError *)error;    //错误报告
@end
