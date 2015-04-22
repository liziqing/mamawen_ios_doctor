//
//  doctorInformationCell3.m
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "doctorInformationCell3.h"

@implementation doctorInformationCell3

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(doctorInformationCell3 *)doctorInformationCell3{
    return [[NSBundle mainBundle]loadNibNamed:@"doctorInformationCell3" owner:nil options:nil][0];
}
@end
