//
//  BDTableVCell.h
//  妈妈问1
//
//  Created by netshow on 15/4/1.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDTableVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UIImageView *BDimage;
@property (weak, nonatomic) IBOutlet UIView *linev;

+(BDTableVCell *)bdtablevCell;
@end
