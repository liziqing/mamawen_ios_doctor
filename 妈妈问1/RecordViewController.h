//
//  RecordViewController.h
//  妈妈问1
//
//  Created by netshow on 15/2/25.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordTableViewCell.h"

#import "RecordHealthViewController.h"
#import "HealthYunViewController.h"

@interface RecordViewController : UIViewController<UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate>
- (IBAction)aa:(UIButton *)sender;

//@property (weak, nonatomic) IBOutlet UIView *segmessageView;

////周的数据
//@property(strong,nonatomic)NSArray *xCoordinatePointWeek;
//@property(strong,nonatomic)NSArray *yCoordinatePointWeek;
//@property(strong,nonatomic)NSArray *yValuePointWeek;
//
////月的数据
//@property(strong,nonatomic)NSArray *xCoordinatePointMonth;
//@property(strong,nonatomic)NSArray *yCoordinatePointMonth;
//@property(strong,nonatomic)NSArray *yValuePointMonth;
//
////年的数据
//@property(strong,nonatomic)NSArray *xCoordinatePointYear;
//@property(strong,nonatomic)NSArray *yCoordinatePointYear;
//@property(strong,nonatomic)NSArray *yValuePointYear;
- (IBAction)addAsk:(UIButton *)sender;

@end
