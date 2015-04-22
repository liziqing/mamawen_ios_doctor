//
//  ChargeTableVcCell1.m
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ChargeTableVcCell1.h"

@implementation ChargeTableVcCell1

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(ChargeTableVcCell1 *)ChargeTableVcCell1{
    return [[NSBundle mainBundle]loadNibNamed:@"ChargeTableVcCell1" owner:nil options:nil][0];
}
@end
