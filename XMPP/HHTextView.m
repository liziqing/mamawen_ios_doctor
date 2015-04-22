//
//  HHTextView.m
//  自定义UITextView增加提示信息
//
//  Created by huangdl on 14/11/26.
//  Copyright (c) 2014年 huangdl. All rights reserved.
//

#import "HHTextView.h"
#import "Constant.h"
@implementation HHTextView
{
    UIView *_coverView;
    UILabel *_placeLabel;
    BOOL _isEmpty;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _coverView = [[UIView alloc]initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor clearColor];
        [self addSubview:_coverView];
        NSInteger num = iphone6 ? 7 : 5;
        _placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / num)];
        if (frame.size.height < 100) {
            _placeLabel.frame = CGRectMake(0, 0, frame.size.width, 30);
        }
        _placeLabel.numberOfLines = 0;
        
        [_coverView addSubview:_placeLabel];
        _placeLabel.textColor = [UIColor lightGrayColor];
        _placeLabel.font = [UIFont systemFontOfSize:13];
        _placeLabel.backgroundColor = [UIColor clearColor];
        [_coverView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
       
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endeditAction) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endeditAction) name:UITextViewTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endeditAction) name:UITextViewTextDidBeginEditingNotification object:nil];
    }
    return self;
}

-(void)endeditAction
{
    if (self.text == nil || self.text.length == 0 || _coverView == nil) {
        [self addSubview:_coverView];
    }
    else
    {
        [_coverView removeFromSuperview];
    }
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeLabel.text = placeHolder;
}

-(void)tapAction
{
    [self endeditAction];
    [self becomeFirstResponder];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}







@end









