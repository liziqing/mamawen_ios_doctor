//
//  RemindListTableVCCell.m
//  妈妈问1
//
//  Created by alex on 15/4/8.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RemindListTableVCCell.h"

@implementation RemindListTableVCCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(RemindListTableVCCell *)remindListTableVCCell{
    return [[NSBundle mainBundle]loadNibNamed:@"RemindListTableVCCell" owner:nil options:nil][0];
}

@end
