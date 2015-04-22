//
//  HealthYunTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "HealthYunTableViewCell.h"

@implementation HealthYunTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+(HealthYunTableViewCell *)HealthYunTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"HealthYunTableViewCell" owner:nil options:nil][0];
}

@end
