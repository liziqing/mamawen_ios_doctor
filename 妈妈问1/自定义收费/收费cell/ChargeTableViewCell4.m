//
//  ChargeTableViewCell4.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "ChargeTableViewCell4.h"

@implementation ChargeTableViewCell4

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(ChargeTableViewCell4 *)ChargeTableViewCell4{
    return [[NSBundle mainBundle]loadNibNamed:@"ChargeTableViewCell4" owner:nil options:nil][0];
}
@end
