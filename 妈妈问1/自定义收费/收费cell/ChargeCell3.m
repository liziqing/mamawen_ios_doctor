//
//  ChargeCell3.m
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ChargeCell3.h"

@implementation ChargeCell3

- (void)awakeFromNib {}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(ChargeCell3 *)ChargeCell3{
    return [[NSBundle mainBundle]loadNibNamed:@"ChargeCell3" owner:nil options:nil][0];
}
@end
