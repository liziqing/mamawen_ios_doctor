//
//  DoctorIntegralTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DoctorIntegralTableViewCell.h"

@implementation DoctorIntegralTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(DoctorIntegralTableViewCell *)DoctorIntegralTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"DoctorIntegralTableViewCell" owner:nil options:nil][0];
}
@end
