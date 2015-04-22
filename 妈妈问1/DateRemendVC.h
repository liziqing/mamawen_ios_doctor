//
//  DateRemendVC.h
//  妈妈问1
//
//  Created by netshow on 15/3/27.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"
#import "DetailContentViewController.h"

@interface DateRemendVC : UIViewController<CalendarDelegate, UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

- (IBAction)backBtn:(UIButton *)sender;

@end
