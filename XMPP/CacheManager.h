//
//  CacheManager.h
//
//
//  Created by huangdl on 14-11-21.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+(id)sharedManager;

-(BOOL)isCacheExist:(NSString *)name; //  name --> messageId

-(NSData *)getCache:(NSString *)name;

-(void)saveCache:(NSData *)data withName:(NSString *)name; // data --> 语音或图片

-(void)saveCache:(NSData *)data withName:(NSString *)name withPage:(NSInteger)page;

@end







