//
//  DBManager.m
//
//
//  Created by huangdl on 14-11-25.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"
@implementation DBManager
{
    FMDatabase *_dbm;
}
+(id)sharedManager
{
    static DBManager *_m = nil;
    if (!_m) {
        _m = [[DBManager alloc]init];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化数据库
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doctorchat.db"];
        _dbm = [[FMDatabase alloc]initWithPath:path];
        if ([_dbm open]) {
            // NSString *sql = @"create table if not exists message(id integer primary key autoincrement,messageid varchar(16),mestime varchar(32),content varchar(1024),senderid varchar(8),senderrole char(1),receiveid varchar(8),receiverole char(1),chatmode char(1),toorfrom varchar(20),inquiryid varchar(8),doctorid varchar(8),category char(1),problem varchar(128),suggest varchar(512))";
            NSString *sql = @"create table if not exists doctormessage(id integer primary key autoincrement,messageid varchar(16),mestime varchar(32),content varchar(1024),senderid varchar(8),senderrole char(1),receiveid varchar(8),receiverole char(1),chatmode char(1),toorfrom varchar(20),inquiryid varchar(8),patientid varchar(8),category char(1),problem varchar(128),suggest varchar(512))";
           BOOL ret= [_dbm executeUpdate:sql];
            NSLog(@"%@",ret?@"建表成功":@"建表失败");
        }
    }
    return self;
}

-(BOOL)isExists:(NSString *)messageId
{
    NSString *sql = @"select messageid from doctormessage where messageid = ?";
    FMResultSet *set = [_dbm executeQuery:sql,messageId];
    return [set next];
}

-(void)insertModel:(MessageModel *)model
{
    NSString *sql = @"insert into doctormessage (messageid,mestime,content,senderid,senderrole,receiveid,receiverole,chatmode,toorfrom,inquiryid,patientid,category,problem,suggest) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    [_dbm executeUpdate: sql,
                         model.messageId,
                         model.mesTime,
                         model.messageBody,
                         [NSString stringWithFormat:@"%ld", (long)model.senderid ],
                         [NSString stringWithFormat:@"%d", model.senderrole ],
                         [NSString stringWithFormat:@"%ld", (long)model.receiveid ],
                         [NSString stringWithFormat:@"%d",model.receiverole],
                         [NSString stringWithFormat:@"%ld", model.cmode ],
                         model.toOrFrom,
                         [NSString stringWithFormat:@"%ld",(long)model.inquiryID],
                         [NSString stringWithFormat:@"%ld",(long)model.patientID],
                         [NSString stringWithFormat:@"%ld",model.ccategory],
                         model.problem,
                         model.suggest];

}

-(void)deleteModel:(MessageModel *)model
{
    NSString *sql = @"delete from doctormessage where messageid = ?";
    [_dbm executeUpdate:sql,model.messageId];
}

-(NSMutableArray *)fetchAll
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    NSString *sql = @"select * from doctormessage";
    FMResultSet *result = [_dbm executeQuery:sql];
    while ([result next]) {
        MessageModel *model = [[MessageModel alloc]init];
        model.messageId = [result stringForColumn:@"messageid"];
        model.mesTime = [result stringForColumn:@"mestime"];
        model.messageBody = [result stringForColumn:@"content"];
        model.senderid = [[result stringForColumn:@"senderid"] integerValue];
        model.senderrole = [[result stringForColumn:@"senderrole"] intValue];
        model.receiveid = [[result stringForColumn:@"receiveid"] integerValue];
        model.receiverole = [[result stringForColumn:@"receiverole"] intValue];
        model.cmode = [[result stringForColumn:@"chatmode"] intValue];
        model.toOrFrom = [result stringForColumn:@"toorfrom"];
        model.inquiryID = [[result stringForColumn:@"inquiryid"] integerValue];
        model.patientID = [[result stringForColumn:@"patientid"] integerValue];
        model.ccategory = [[result stringForColumn:@"category"] intValue];
        model.problem = [result stringForColumn:@"problem"];
        model.suggest = [result stringForColumn:@"suggest"];
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




