//
//  MessageModel.m
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "MessageModel.h"
#import "NSData+Base64.h"
@implementation MessageModel

{
    NSString *_lastTime;
}
- (UIImage *)image {
// message 转成nsdata -- 》 image
    
    NSData *data = [NSData dataWithBase64EncodedString:_message];
    if (_message.length < 5) {
        return nil;
    }
    int char1 = 0,char2 = 0;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];

    NSString *str = [NSString stringWithFormat:@"%i%i",char1,char2];
//    NSLog(@"pic---%@",str);
    if (data == nil || ![str isEqualToString:@"255216"]) {
        return nil;
    }
    UIImage *img = [[UIImage alloc] initWithData:data];
    if (img == nil) {
        return nil;
    }
    
   else return [UIImage imageWithData:UIImageJPEGRepresentation(img, 0.5)];
}
- (BOOL)isVideo {
    
    
    if (_message.length < 5) {
        return NO;
    }
    
        NSData *data = [NSData dataWithBase64EncodedString:_message];
    int char1 = 0,char2 = 0;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    
    NSString *str = [NSString stringWithFormat:@"%i%i",char1,char2];
//    NSLog(@"video---%@",str);
    if ([str isEqualToString:@"3533"]) {
        return YES;
    }
    else return NO;
}
- (BOOL)isShowTime {
    if (_isFirstMes) {
        return YES;
    }
    if (!_mesTime) {
        return NO;
    } else {
        NSTimeInterval diffTime = [self diffTimeWithTimeStr:_mesTime];
        
        if (diffTime  >= 5 * 60) {
            
            
            return YES;
        }else return NO;
    
    }
}
- (NSTimeInterval)diffTimeWithTimeStr:(NSString *)timeStr {
    NSDateFormatter *dfm = [[NSDateFormatter alloc] init];
    [dfm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dfm dateFromString:timeStr];
    NSTimeInterval diffTime = [date timeIntervalSinceNow];
    return diffTime;
}
- (NSString *)showTime {
    return [self timeStringWithDate:_mesTime];
}
#pragma mark -
#pragma mark 转换时间string
- (NSString *)timeStringWithDate:(NSString *)dateString {
    if (dateString == nil || dateString.length == 0) {
        return nil;
    }
    
    NSArray *arr = [dateString componentsSeparatedByString:@" "];
    NSString *dayStr = [arr firstObject];
    NSDate *today = [NSDate date];
    NSDateFormatter *fomat = [[NSDateFormatter alloc] init];
    [fomat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayStr = [fomat stringFromDate:today];
    
    if ([dayStr isEqualToString:todayStr]) {
        return arr[1];
    } else return dateString;
}
- (void)setReportDic:(NSDictionary *)reportDic {
    _problem = reportDic[@"problem"];
    _suggest = reportDic[@"suggest"];
//    NSLog(@"reprotDic:%@ -- problem:%@ -- suggest:%@",reportDic,_problem,_suggest);
}
- (void)setSenderDic:(NSDictionary *)senderDic {
    _senderid = [senderDic[@"id"] integerValue];
    _senderrole = [senderDic[@"role"] intValue];
}
- (void)setReceiveDic:(NSDictionary *)receiveDic {
    _receiveid = [receiveDic[@"id"] integerValue];
    _receiverole = [receiveDic[@"role"] intValue];
}

@end
