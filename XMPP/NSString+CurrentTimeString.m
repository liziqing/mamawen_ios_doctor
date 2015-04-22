//
//  NSString+CurrentTimeString.m
//  妈妈问
//
//  Created by kin on 15/4/1.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "NSString+CurrentTimeString.h"

@implementation NSString (CurrentTimeString)
+(NSString *)getCurrentTimeString {
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}
+ (NSString *)getDocumentPathWithSuffixCompoment:(NSString *)suffix {
    return [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",suffix]];
}
@end
