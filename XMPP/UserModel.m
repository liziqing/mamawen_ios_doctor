//
//  UserModel.m
//  chatdemo
//
//  Created by lixuan on 15/2/3.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (BOOL)isOnline {
    if ([self.status isEqualToString:@"online"]) {
        return YES;
    }
    else return NO;
}
@end
