//
//  InformationCell.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(InformationCell *)InformationCell{
    return [[NSBundle mainBundle]loadNibNamed:@"InformationCell" owner:nil options:nil][0];
}

@end
