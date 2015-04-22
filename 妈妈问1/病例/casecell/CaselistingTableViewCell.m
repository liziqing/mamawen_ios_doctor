//
//  CaselistingTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "CaselistingTableViewCell.h"

@implementation CaselistingTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.dianview.layer.cornerRadius=5;
    self.dianview.layer.masksToBounds=YES;
}

+(CaselistingTableViewCell *)caselisting{
    return [[NSBundle mainBundle]loadNibNamed:@"CaselistingTableViewCell" owner:nil options:nil][0];
}
@end
