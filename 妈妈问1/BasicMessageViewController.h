//
//  BasicMessageViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "BackView.h"
#import "OutpatientViewController.h"
@class TabBarViewController;

@interface BasicMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,OutpatientViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *doctorNameText;
//Lable
@property (weak, nonatomic) IBOutlet UILabel *hospitalLable;
@property (weak, nonatomic) IBOutlet UILabel *officeLable;
@property (weak, nonatomic) IBOutlet UILabel *zhichenLable;
@property (weak, nonatomic) IBOutlet UILabel *menzhenTimeLable;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImage;
@property (weak, nonatomic) IBOutlet UIImageView *officeImage;
@property (weak, nonatomic) IBOutlet UIImageView *zhichengImage;
@property (weak, nonatomic) IBOutlet UIImageView *menzhenTimeImage;


//接收上界面的信息
@property(strong,nonatomic)NSString *doctorChenni;
@property(strong,nonatomic)NSString *doctorPsd;

- (IBAction)actionIcon:(UIButton *)sender;

@end
