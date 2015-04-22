//
//  AppDelegate.h
//  妈妈问1
//
//  Created by netshow on 15/2/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
//---------个推-------
#import "GexinSdk.h"

@class ViewController;

typedef enum {
    SdkStatusStoped,
    SdkStatusStarting,
    SdkStatusStarted
} SdkStatus;

//-------------------


@interface AppDelegate : UIResponder <UIApplicationDelegate,GexinSdkDelegate>{

@private
    NSString *token;
}

@property (strong, nonatomic) UIWindow *window;

//-----------个推------------
@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;  //创建实例

- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

- (NSString *)testGetClientId;

@end

