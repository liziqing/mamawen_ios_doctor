//
//  ChargeTableVcCell2.m
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ChargeTableVcCell2.h"

@implementation ChargeTableVcCell2

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(ChargeTableVcCell2 *)ChargeTableVcCell2{
    return [[NSBundle mainBundle]loadNibNamed:@"ChargeTableVcCell2" owner:nil options:nil][0];
}
@end
