//
//  DetailContentTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/6.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DetailContentTableViewCell.h"

@implementation DetailContentTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(DetailContentTableViewCell *)detailContentTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"DetailContentTableViewCell" owner:nil options:nil][0];
}


@end
