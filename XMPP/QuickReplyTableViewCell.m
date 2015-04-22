//
//  QuickReplyTableViewCell.m
//  妈妈问1
//
//  Created by lixuan on 15/3/16.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "QuickReplyTableViewCell.h"
#import "Constant.h"
@implementation QuickReplyTableViewCell
{
    UILabel *_titleLable;
    UIImageView *_imgV;
    UILabel *_timeLable;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, kScreenWidth / 2, 30)];
        _titleLable.font = [UIFont systemFontOfSize:iphone6? 18 : 16];
        _titleLable.numberOfLines = 0;
        _titleLable.textColor = [UIColor whiteColor];
        [self addSubview:_titleLable];
        
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLable.frame) + 5, 5, kScreenWidth / 4, 30)];
        _imgV.backgroundColor = [UIColor colorWithRed:0.13 green:0.74 blue:0.8 alpha:1];
        [self addSubview:_imgV];
        
        _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame) + 3, 8, 40, 30)];
        _timeLable.font = _titleLable.font;
        _timeLable.textColor = [UIColor whiteColor];
        [self addSubview:_timeLable];
    }
    return self;
}
- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(QuickReplyModel *)model {
    

    
    _titleLable.text = model.mesTitle;
    _timeLable.text  = [NSString stringWithFormat:@"%@''",model.msgTime];
    
    
}

@end
