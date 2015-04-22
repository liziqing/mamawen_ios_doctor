//
//  VisitViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/11.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "BackView.h"
#import "InformationTableViewCell.h"

@interface VisitViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSArray *informationLableArray; //患者消息的字典数据

@end
