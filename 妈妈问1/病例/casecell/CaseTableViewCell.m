//
//  CaseTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "CaseTableViewCell.h"

@implementation CaseTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.patientHeadImage.layer.cornerRadius=35;
    self.patientHeadImage.layer.masksToBounds=YES;
}

+(CaseTableViewCell *)CaseTableViewCell{
    return [[NSBundle mainBundle]loadNibNamed:@"CaseTableViewCell" owner:nil options:nil][0];
}
@end
