//
//  CaseTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *patientHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *patientNameLable;  //患者名字
@property (weak, nonatomic) IBOutlet UILabel *patientSubheadLable;  //患者其它简要信息

+(CaseTableViewCell *)CaseTableViewCell;

@end
