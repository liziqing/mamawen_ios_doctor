//
//  DateData.h
//  妈妈问1
//
//  Created by alex on 15/4/10.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateData : NSObject


@property(strong,atomic)NSString *titleString;
@property(strong,atomic)NSString *timeString;
@property(strong,atomic)NSString *patientString;
@property(assign,atomic)BOOL remindMe;
@property(assign,atomic)BOOL remindPatient;
@property(strong,atomic)NSString *remindNumString;
@property(strong,atomic)NSString *contentString;
@property(strong,atomic)NSString *reminderID;

@property(strong,nonatomic)NSString *remindTimeString;
@property(strong,atomic)NSString *startTimeString;
@property(strong,atomic)NSString *endTimeString;

+(DateData *)shareDateData;

@end
