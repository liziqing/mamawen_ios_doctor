//
//  Hospital.h
//  妈妈问1
//
//  Created by alex on 15/4/21.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Hospital : UIViewController


//----------标识-------


- (IBAction)backBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *mytitleLable;

@property(assign,nonatomic)NSInteger hospitalInfo;
@property(strong,nonatomic)NSString *namecell;


@end
