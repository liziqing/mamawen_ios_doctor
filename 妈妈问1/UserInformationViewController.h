//
//  UserInformationViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/17.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DoctorInformationViewController.h"
#import "BackView.h"
#import "UserInformationTableViewCell.h"
#import "DoctorIntegralTableViewCell.h"

@interface UserInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *doctorInformationTableView;

@end
