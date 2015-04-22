//
//  DBManager.h
//
//
//  Created by huangdl on 14-11-25.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
@interface DBManager : NSObject

+(id)sharedManager;

-(BOOL)isExists:(NSString *)messageId;

-(void)insertModel:(MessageModel *)model;

-(void)deleteModel:(MessageModel *)model;

-(NSMutableArray *)fetchAll;

//事务:从开启事务到提交事务之前,所有的操作都是可以回滚的
//开启事务
-(void)beginTransaction;
//回滚
-(void)rollback;
//提交
-(void)commit;


@end








