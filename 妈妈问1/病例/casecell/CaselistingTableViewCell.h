//
//  CaselistingTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/3/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaselistingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dianview;


+(CaselistingTableViewCell *)caselisting;

@end
