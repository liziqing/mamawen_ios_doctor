//
//  InformationTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(InformationTableViewCell *)InformationTableViewCell1{
    return [[NSBundle mainBundle]loadNibNamed:@"InformationTableViewCell" owner:nil options:nil][0];
}
@end
