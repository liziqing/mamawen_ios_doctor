//
//  AffirmClinicalTableViewCell.h
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@protocol affirmClinicalTableViewCellDelegate <NSObject>

-(void)changeCellHeight:(NSInteger)cellHeight;

@end

@interface AffirmClinicalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *askHeadImage;   //头像
@property (weak, nonatomic) IBOutlet UILabel *affirmNameLable;  //提问者姓名
@property (weak, nonatomic) IBOutlet UILabel *affirmLable2;     //提问者副标题

@property (strong, nonatomic) UILabel *affirmLable4;          //问题
@property (weak, nonatomic) UILabel *affirmLablePicture;      //

@property(assign,nonatomic)NSInteger a;
@property(strong,nonatomic)NSTimer *time;

@property(strong,nonatomic)NSString *askName3;        //提问者用户名
@property(strong,nonatomic)NSString *askSubhead3;    //提问者副标题
@property(strong,nonatomic)NSString *askIntegral3;  //回答问题获取的金币
@property(strong,nonatomic)NSString *askString3;    //提问者问题
@property(strong,nonatomic)NSString *askPictureNumber3;  //提问者上传的图片数

@property(strong,nonatomic)UILabel *shijian;   //剩余时间

+(AffirmClinicalTableViewCell *)AffirmClinicalTableViewCell;

@property(assign,nonatomic)id<affirmClinicalTableViewCellDelegate>delegate;

-(void)addOther;
@end
