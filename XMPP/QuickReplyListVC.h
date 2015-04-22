//
//  QuickReplyListVC.h
//  妈妈问1
//
//  Created by kin on 15/4/8.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickReplyListVC : UIViewController
@property (nonatomic, copy) void(^selectMessage)(NSData *audioData,NSString *path);
@end
