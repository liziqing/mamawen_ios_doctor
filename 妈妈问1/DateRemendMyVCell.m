//
//  DateRemendMyVCell.m
//  妈妈问1
//
//  Created by netshow on 15/4/2.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "DateRemendMyVCell.h"

@implementation DateRemendMyVCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(DateRemendMyVCell *)DateRemendMyVCell{
      return [[NSBundle mainBundle]loadNibNamed:@"DateRemendMyVCell" owner:nil options:nil][0];
}
@end
