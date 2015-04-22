//
//  ForgetPSDViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPSDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ponenumber;
@property (weak, nonatomic) IBOutlet UIImageView *poneimage;

@property (weak, nonatomic) IBOutlet UITextField *yanznumber;
@property (weak, nonatomic) IBOutlet UIImageView *yanzimage;

@property (weak, nonatomic) IBOutlet UIButton *yanz;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


- (IBAction)backBtn:(UIButton *)sender;

@end
