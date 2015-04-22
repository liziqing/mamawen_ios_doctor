//
//  DetailAmendViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/7.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackView.h"

@interface DetailAmendViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *detaiAmend;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property(strong,nonatomic)NSString *titleStr;

- (IBAction)backAction:(UIButton *)sender;

@end
