//
//  MyTableViewCell3.m
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "MyTableViewCell3.h"

@implementation MyTableViewCell3

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.cell3mylable1.font=[UIFont systemFontOfSize:13.0f];
    
    self.cell3mylable2.font=[UIFont systemFontOfSize:12.0f];
    
    self.cell3mylable3.font=[UIFont systemFontOfSize:13];
    
    self.cell3mylable4.numberOfLines=3;
    self.cell3mylable4.font=[UIFont systemFontOfSize:13.0f];
}

+(MyTableViewCell3 *)Mytableviewcell3{
    return [[NSBundle mainBundle]loadNibNamed:@"MyTableViewCell3" owner:nil options:nil][0];
}
@end
