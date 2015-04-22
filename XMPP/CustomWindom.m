//
//  Custom.m
//  chatdemo
//
//  Created by lixuan on 15/2/9.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "CustomWindom.h"



@implementation CustomWindom

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) { // 发送一个名为 'nScreenTouch' (自定义) 的事件
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"nScreenTouch" object:nil userInfo:[NSDictionary dictionaryWithObject:event forKey:@"data"]]];
    }
    [super sendEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
