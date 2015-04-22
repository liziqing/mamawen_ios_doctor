//
//  RevampPsdVC.h
//  妈妈问1
//
//  Created by netshow on 15/3/30.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RevampPsdVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *originalText;
@property (weak, nonatomic) IBOutlet UITextField *psdNew1;
@property (weak, nonatomic) IBOutlet UITextField *psdNew2;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

- (IBAction)backBtn:(UIButton *)sender;
@end
