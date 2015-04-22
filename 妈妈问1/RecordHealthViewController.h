//
//  RecordHealthViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@interface RecordHealthViewController : UIViewController<UIScrollViewDelegate>

- (IBAction)returnAction:(UIButton *)sender;//navigationbar上的返回按钮
- (IBAction)segmentAction:(UISegmentedControl *)sender;//navigationbar上得分段控件
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollview;//主视图上得scrollview

@property (weak, nonatomic) IBOutlet UIButton *contactPatient; //联系患者按钮属性

- (IBAction)contactPatientIcon:(UIButton *)sender; //联系患者方法

//周的数据
@property(strong,nonatomic)NSArray *xCoordinatePointWeek2;
@property(strong,nonatomic)NSArray *yCoordinatePointWeek2;
@property(strong,nonatomic)NSArray *yValuePointWeek2;

//月的数据
@property(strong,nonatomic)NSArray *xCoordinatePointMonth2;
@property(strong,nonatomic)NSArray *yCoordinatePointMonth2;
@property(strong,nonatomic)NSArray *yValuePointMonth2;

//年的数据
@property(strong,nonatomic)NSArray *xCoordinatePointYear2;
@property(strong,nonatomic)NSArray *yCoordinatePointYear2;
@property(strong,nonatomic)NSArray *yValuePointYear2;

@end
