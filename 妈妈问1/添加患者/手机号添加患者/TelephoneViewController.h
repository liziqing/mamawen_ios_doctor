//
//  TelephoneViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelephoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *telePhone;
- (IBAction)backAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *jianBtn;


@end
