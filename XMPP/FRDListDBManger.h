//
//  FRDListDBManger.h
//  妈妈问1
//
//  Created by kin on 15/4/10.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsModel.h"
@interface FRDListDBManger : NSObject

+(id)sharedManager;

-(BOOL)isExists:(NSString *)phoneNum;

-(void)insertModel:(FriendsModel *)model;

-(void)deleteModel:(FriendsModel *)model;

-(NSMutableArray *)fetchAll;

//事务:从开启事务到提交事务之前,所有的操作都是可以回滚的
//开启事务
-(void)beginTransaction;
//回滚
-(void)rollback;
//提交
-(void)commit;

@end
