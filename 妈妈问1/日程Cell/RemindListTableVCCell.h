//
//  RemindListTableVCCell.h
//  妈妈问1
//
//  Created by alex on 15/4/8.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemindListTableVCCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageInfo;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;






+(RemindListTableVCCell *)remindListTableVCCell;

@end
