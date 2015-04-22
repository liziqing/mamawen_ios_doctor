//
//  DateRemendContentCell.m
//  妈妈问1
//
//  Created by alex on 15/4/3.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DateRemendContentCell.h"

@implementation DateRemendContentCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}







+(DateRemendContentCell *)dateRemendContentCell{
    return [[NSBundle mainBundle]loadNibNamed:@"DateRemendContentCell" owner:nil options:nil][0];
}

@end
