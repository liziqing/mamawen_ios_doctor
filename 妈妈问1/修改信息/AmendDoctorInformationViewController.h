//
//  AmendDoctorInformationViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmendDoctorInformationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *amendTitleLable;
@property (weak, nonatomic) IBOutlet UITextField *amendInformation;//修改的文本
@property (assign,nonatomic) NSInteger cellInfo;  //跳转过来的cell 的标识
@property(strong,nonatomic)NSString *textStr;  //接受上一界面传过来的string
- (IBAction)backBtn:(UIButton *)sender;   //返回按钮事件

@end
