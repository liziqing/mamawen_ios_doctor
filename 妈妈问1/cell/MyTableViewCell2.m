//
//  MyTableViewCell2.m
//  b
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "MyTableViewCell2.h"

@implementation MyTableViewCell2

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.mylable1.font=[UIFont systemFontOfSize:13.0f];
}

+(MyTableViewCell2 *)Mytableviewcell2{
    return [[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell2" owner:nil options:nil][0];
}

@end
