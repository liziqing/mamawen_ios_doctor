//
//  CaseViewController.h
//  妈妈问1
//
//  Created by netshow on 15/3/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic)NSString *paitientuid;

- (IBAction)back:(UIButton *)sender;

@end
