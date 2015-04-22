//
//  doctorInformationCell3.h
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface doctorInformationCell3 : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIView *line;

+(doctorInformationCell3 *)doctorInformationCell3;
@end
