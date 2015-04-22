//
//  DateData.m
//  妈妈问1
//
//  Created by alex on 15/4/10.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DateData.h"

@implementation DateData


static DateData *dateRemind;

+(DateData *)shareDateData{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        dateRemind = [[DateData alloc] init];
    });
    return dateRemind;
}


@end
