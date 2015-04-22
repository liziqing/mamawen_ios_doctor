//
//  AffirmViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AffirmClinicalTableViewCell.h"
#import "BackView.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "VisitViewController.h"

@interface AffirmViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,affirmClinicalTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *affirmclinicalTableView;

@property(strong,nonatomic)NSString *askstring;//接收提问者的问题
@property(strong,nonatomic)NSString *askName2;//提问者名字
@property(strong,nonatomic)NSString *askSubhead2;//提问者副标题
@property(strong,nonatomic)NSString *askIntegral2;//回答问题得到的金币
@property(strong,nonatomic)NSString *askPictureNumber2; //提问者上传的图片数
@property(strong,nonatomic)NSString *askID;

@property(strong,nonatomic)NSDictionary *askDataDictionary; //获取单个用户的数据

//-----------------------------------he----------------------------------
@property(strong,nonatomic)NSString *patientjid;
@property(strong,nonatomic)NSString *patientuid;   //用户ID
@property(strong,nonatomic)NSString *patientsessionkey;
@property(strong,nonatomic)NSString *patientinquiryID;  //问题ID

//-------------------------------------he-----------------------


- (IBAction)affirmInquiryBtnClick:(id)sender;

@end
