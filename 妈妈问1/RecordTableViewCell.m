//
//  RecordTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/3/3.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "RecordTableViewCell.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(RecordTableViewCell *)RecordView{
    return [[NSBundle mainBundle]loadNibNamed:@"RecordTableViewCell" owner:nil options:nil][0];
}

-(void)dataUpdate{
    self.recordAskHeadImage.layer.cornerRadius=20;
    self.recordAskHeadImage.layer.masksToBounds=YES;
    
    //self.recordAskTime.text=
}
@end
