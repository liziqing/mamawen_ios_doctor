//
//  PersonalTableViewCell2.m
//  妈妈问1
//
//  Created by netshow on 15/3/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "PersonalTableViewCell2.h"

@implementation PersonalTableViewCell2

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(PersonalTableViewCell2 *)personaltableviewcell2{
    return [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell2" owner:nil options:nil][0];
}
@end
