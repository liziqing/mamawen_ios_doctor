//
//  PatitentTableViewCell.m
//  妈妈问1
//
//  Created by alex on 15/4/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "PatitentTableViewCell.h"

@implementation PatitentTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(PatitentTableViewCell *)patitentTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"PatitentTableViewCell" owner:nil options:nil][0];
}

@end
