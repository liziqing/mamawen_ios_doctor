//
//  DetailContentViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/13.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackView.h"
#import "DetailContentTableViewCell.h"
#import "DetailAmendViewController.h"

@interface DetailContentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

//接收日程提醒详细内容字符串

@property(strong,nonatomic)NSString *remindTimeStr;    //作为参数的提醒时间
@property(strong,nonatomic)NSString *startDateStr;      //开始日期
@property(strong,nonatomic)NSString *endDataStr;        //结束日期

@property(assign,nonatomic)NSInteger finishInfo;  //判断是上一界面那一个控件的跳转

- (IBAction)backBtn:(UIButton *)sender;

@end
