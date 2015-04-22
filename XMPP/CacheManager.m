//
//  CacheManager.m
// 
//
//  Created by huangdl on 14-11-21.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "CacheManager.h"
#import "NSString+MD5Addition.h"
@implementation CacheManager
{
    NSFileManager *_fileManager;
    NSString *_rootPath;
}
+(id)sharedManager
{
    static CacheManager *_m = nil;
    if (!_m) {
        _m = [[CacheManager alloc]init];
    }
    return _m;
}

//初始化的作用是对当前的单例的运行环境进行配置
- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _rootPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"mycache"];
        NSLog(@"%@",_rootPath);
        //创建目录
        if (![_fileManager fileExistsAtPath:_rootPath]) {
            [_fileManager createDirectoryAtPath:_rootPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

-(BOOL)isCacheExist:(NSString *)name
{
    NSString *path = [self getPathWithName:name];
    return [_fileManager fileExistsAtPath:path];
}

-(NSData *)getCache:(NSString *)name
{
    NSString *path = [self getPathWithName:name];
    return [NSData dataWithContentsOfFile:path];
}

-(void)saveCache:(NSData *)data withName:(NSString *)name
{
    NSString *path = [self getPathWithName:name];
    [data writeToFile:path atomically:NO];
}

-(NSString *)getPathWithName:(NSString *)name
{
    NSString *md5Path = [name stringFromMD5];
    return [_rootPath stringByAppendingPathComponent:md5Path];
}

-(void)saveCache:(NSData *)data withName:(NSString *)name withPage:(NSInteger)page
{
    NSString *path = [self getPathWithName:name];
    //如果page==1,应该直接写缓存,否则加到原缓存后面
    if (page == 1) {
        [self saveCache:data withName:name];
    }
    else
    {
        //1.取出原缓存的数据
        NSData *source = [self getCache:name];
        //2.解析原数据
           
        NSDictionary *sdic = [NSJSONSerialization JSONObjectWithData:source options:NSJSONReadingMutableContainers error:nil];
        NSArray *sarr = sdic[@"applications"];
        
        //3.解析现有数据
        NSDictionary *tdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *tarr = tdic[@"applications"];
        
        //4.拼接两部分数据
        NSMutableArray *resArr = [[NSMutableArray alloc]init];
        [resArr addObjectsFromArray:sarr];
        [resArr addObjectsFromArray:tarr];
        
        NSDictionary *resDic = @{@"applications":resArr};
        
        //5.将拼接好的数据转换成NSData,并保存
        NSData *resData = [NSJSONSerialization dataWithJSONObject:resDic options:NSJSONWritingPrettyPrinted error:nil];
        [self saveCache:resData withName:name];
    }
    //保存对应的页数
    [[NSUserDefaults standardUserDefaults]setValue:@(page) forKey:name];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end






