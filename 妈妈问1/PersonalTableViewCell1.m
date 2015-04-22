//
//  PersonalTableViewCell1.m
//  妈妈问1
//
//  Created by netshow on 15/3/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "PersonalTableViewCell1.h"

@implementation PersonalTableViewCell1

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.userHeadImage.layer.cornerRadius=20;
    self.userHeadImage.layer.masksToBounds=YES;
    
}

+(PersonalTableViewCell1 *)PersonalTableViewCell1
{
    return [[NSBundle mainBundle]loadNibNamed:@"PersonalTableViewCell1" owner:nil options:nil][0];
}

@end
