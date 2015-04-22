//
//  UserInformationTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImage;  //医生头像

//@property (weak, nonatomic) IBOutlet UILabel *doctorID; //医生ID

@property(strong,nonatomic)UILabel *doctorNameLable;  //医生名字
@property(strong,nonatomic)UILabel *doctorInfoLable;  // 注册与否标识

+(UserInformationTableViewCell *)UserInformationTableViewCell;
@end
