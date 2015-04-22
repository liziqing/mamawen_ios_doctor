//
//  SetCell.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(SetCell *)SetCell;{
    return [[NSBundle mainBundle]loadNibNamed:@"SetCell" owner:nil options:nil][0];
}
@end
