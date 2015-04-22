//
//  BackView.m
//  妈妈问1
//
//  Created by netshow on 15/3/11.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "BackView.h"

@implementation BackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        backImageView.image=[UIImage imageNamed:@"backimage.jpg"];
        [self addSubview:backImageView];
    }
    return self;
}


@end
