//
//  DetailContentTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/6.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailContentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@property (weak, nonatomic) IBOutlet UILabel *titleLable1;

@property(strong,nonatomic)NSString *titleContent;
@property(strong,nonatomic)NSString *timeContent;
@property(strong,nonatomic)NSString *patientName;



+(DetailContentTableViewCell *)detailContentTableViewCell;


@end
