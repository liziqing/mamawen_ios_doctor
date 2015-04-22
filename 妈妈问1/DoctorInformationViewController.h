//
//  DoctorInformationViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/18.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalTableViewCell1.h"
#import "PersonalTableViewCell2.h"
#import "UserInfo.h"
#import "BackView.h"

@interface DoctorInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic)UITableView *doctorInformationTableView;

- (IBAction)backBtn:(UIButton *)sender;
@end
