//
//  SettingViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *setingtableview;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)backBtn:(UIButton *)sender;

@end
