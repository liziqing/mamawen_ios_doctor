//
//  FRDListDBManger.m
//  妈妈问1
//
//  Created by kin on 15/4/10.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "FRDListDBManger.h"
#import "FMDatabase.h"
@implementation FRDListDBManger

{
    FMDatabase *_dbm;
}
+(id)sharedManager
{
    static FRDListDBManger *_m = nil;
    if (!_m) {
        _m = [[FRDListDBManger alloc]init];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化数据库
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/friendlist.db"];
        _dbm = [[FMDatabase alloc]initWithPath:path];
        if ([_dbm open]) {
            
            NSString *sql = @"create table if not exists friend(id integer primary key autoincrement,patientid varchar(16),portraitPath varchar(128),name varchar(32),phone varchar(16),doctorid varchar(16))";
            BOOL ret      = [_dbm executeUpdate:sql];
            NSLog(@"friendlist.db:%@",ret?@"建表成功":@"建表失败");
        }
    }
    return self;
}

-(BOOL)isExists:(NSString *)phoneNum
{
    NSString *sql = @"select phone from friend where phone = ?";
    FMResultSet *set = [_dbm executeQuery:sql,phoneNum];
    return [set next];
}

-(void)insertModel:(FriendsModel *)model
{
    NSString *sql = @"insert into friend (patientid,portraitPath,name,phone,doctorid) values (?,?,?,?,?)";
    [_dbm executeUpdate: sql,
                        model.patientid,
                        model.portraitPath,
                        model.name,
                        model.phone,
                        model.doctoerid];
    
}

-(void)deleteModel:(FriendsModel *)model
{
    NSString *sql = @"delete from friend where phone = ?";
    [_dbm executeUpdate:sql,model.phone];
}

-(NSMutableArray *)fetchAll
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *sql       = @"select * from friend";
    FMResultSet *result = [_dbm executeQuery:sql];
    while ([result next]) {
        FriendsModel *model = [[FriendsModel alloc]init];
        model.patientid     = [result stringForColumn:@"patientid"];
        model.portraitPath  = [result stringForColumn:@"portraitPath"];
        model.name          = [result stringForColumn:@"name"];
        model.phone         = [result stringForColumn:@"phone"];
        model.doctoerid     = [result stringForColumn:@"doctorid"];
        [arr addObject:model];
    }
    
    return arr;
}

//开启事务
-(void)beginTransaction
{
    if (![_dbm inTransaction]) {
        [_dbm beginTransaction];
    }
}
//回滚
-(void)rollback
{
    if ([_dbm inTransaction]) {
        [_dbm rollback];
    }
}
//提交
-(void)commit
{
    if ([_dbm inTransaction]) {
        [_dbm commit];
    }
}

@end
