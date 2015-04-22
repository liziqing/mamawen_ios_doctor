//
//  UpLoadPhoteViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/26.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadPhoteViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)backBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *gongpaiview;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIImageView *jiaimage;


@property (weak, nonatomic) IBOutlet UILabel *mylable1;
@property (weak, nonatomic) IBOutlet UILabel *mylable2;
@property (weak, nonatomic) IBOutlet UILabel *mylable3;
@property (weak, nonatomic) IBOutlet UILabel *mylable4;

@end
