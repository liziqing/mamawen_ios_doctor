//
//  RecordTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/3.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recordAskHeadImage; //头像

@property (weak, nonatomic) IBOutlet UILabel *recordLableAskName; //患者用户名
@property (weak, nonatomic) IBOutlet UILabel *recordAskTime;  //更新时间


+(RecordTableViewCell *)RecordView;

-(void)dataUpdate;
@end
