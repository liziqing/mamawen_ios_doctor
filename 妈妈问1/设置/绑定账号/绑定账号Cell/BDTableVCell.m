//
//  BDTableVCell.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "BDTableVCell.h"

@implementation BDTableVCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(BDTableVCell *)bdtablevCell{
    return [[NSBundle mainBundle]loadNibNamed:@"BDTableVCell" owner:nil options:nil][0];
}
@end
