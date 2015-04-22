//
//  HealthYunViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthYunTableViewCell.h"

@interface HealthYunViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *healthTableView;

@property(strong,nonatomic)NSString *paitientUid;
@property(strong,nonatomic)NSString *askID;//问题ID

@property(strong,nonatomic)NSString *paitientName;
@property(strong,nonatomic)NSString *paitentcontent;

- (IBAction)healthviewback:(UIButton *)sender;

@end
