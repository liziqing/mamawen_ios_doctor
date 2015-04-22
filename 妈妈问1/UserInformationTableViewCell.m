//
//  UserInformationTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "UserInformationTableViewCell.h"

@implementation UserInformationTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.doctorHeadImage.layer.cornerRadius=25;
    self.doctorHeadImage.layer.masksToBounds=YES;
}

+(UserInformationTableViewCell *)UserInformationTableViewCell{
    
    return [[NSBundle mainBundle]loadNibNamed:@"UserInformationTableViewCell" owner:nil options:nil][0];
}

@end
