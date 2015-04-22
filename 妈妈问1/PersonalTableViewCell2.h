//
//  PersonalTableViewCell2.h
//  妈妈问1
//
//  Created by netshow on 15/3/4.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *personalcell2Name;//名字
@property (weak, nonatomic) IBOutlet UILabel *personalcellContent;//内容
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *minImage;

+(PersonalTableViewCell2 *)personaltableviewcell2;

@end
