//
//  PonePSD.h
//  妈妈问1
//
//  Created by alex on 15/4/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PonePSD : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *newpsd;
@property (weak, nonatomic) IBOutlet UITextField *newpsdText;
@property (weak, nonatomic) IBOutlet UIImageView *newpsd2;

@property (weak, nonatomic) IBOutlet UITextField *newpadText2;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;


@property(strong,nonatomic)NSString *poneNum;
- (IBAction)backBtn:(UIButton *)sender;

@end
