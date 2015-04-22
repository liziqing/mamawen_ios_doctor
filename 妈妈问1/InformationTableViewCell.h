//
//  InformationTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell

+(InformationTableViewCell *)InformationTableViewCell1;

@property (weak, nonatomic) IBOutlet UIImageView *askHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *askNameLable;
@property (weak, nonatomic) IBOutlet UILabel *askTime;
@property (weak, nonatomic) IBOutlet UILabel *askContent;


@end
