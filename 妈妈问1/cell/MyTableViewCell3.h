//
//  MyTableViewCell3.h
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCell3 : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *cell3mylable1;
@property (weak, nonatomic) IBOutlet UILabel *cell3mylable2;
@property (weak, nonatomic) IBOutlet UILabel *cell3mylable3;
@property (weak, nonatomic) IBOutlet UILabel *cell3mylable4;

@property (weak, nonatomic) IBOutlet UILabel *pictureNumberLable;

+(MyTableViewCell3 *)Mytableviewcell3;
@end
