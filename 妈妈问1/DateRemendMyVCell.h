//
//  DateRemendMyVCell.h
//  妈妈问1
//
//  Created by netshow on 15/4/2.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateRemendMyVCell : UITableViewCell

@property(assign,nonatomic)NSInteger switchNumber;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

+(DateRemendMyVCell *)DateRemendMyVCell;
@end
