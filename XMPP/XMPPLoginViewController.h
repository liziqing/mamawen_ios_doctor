//
//  ViewController.h
//  chatdemo
//
//  Created by lixuan on 15/2/2.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  XMPPLoginViewController: UIViewController
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *userNAmeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
- (IBAction)registerClick:(UIButton *)sender;
- (IBAction)loginClick:(UIButton *)sender;

@property (nonatomic, copy) NSString *myJid;
@property (nonatomic, copy) NSString *password;
- (void)loginOpenfire;
- (void)offLine;

+ (void)loginOpenfire;
+ (void)offLine;
+(void)reconnect;
@property (nonatomic, assign) BOOL hasLoginOnce;
@end

