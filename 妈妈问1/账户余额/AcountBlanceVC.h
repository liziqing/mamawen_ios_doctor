//
//  AcountBlanceVC.h
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AcountBlanceVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic)NSInteger moneyVCinfo;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

- (IBAction)backBtn:(UIButton *)sender;

@end
