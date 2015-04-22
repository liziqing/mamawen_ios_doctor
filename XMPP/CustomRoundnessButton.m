//
//  CustomRoundnessButton.m
//  chatdemo
//
//  Created by lixuan on 15/2/28.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "CustomRoundnessButton.h"

@implementation CustomRoundnessButton


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
        [self setTitle:@"" forState:UIControlStateNormal];
//        [self setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
