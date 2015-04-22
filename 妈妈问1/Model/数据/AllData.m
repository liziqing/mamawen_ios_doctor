//
//  AllData.m
//  妈妈问1
//
//  Created by alex on 15/4/22.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AllData.h"

@implementation AllData

-(id)init{
    self=[super init];
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"baobaoSG.plist" ofType:nil];
        self.bbsgArray = [NSArray arrayWithContentsOfFile:path];
        
        self.bbsgminArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bbsgmin" ofType:@"plist"]];
        
        NSString *path1=[[NSBundle mainBundle] pathForResource:@"hospital.json" ofType:nil];
        NSURL *url=[NSURL fileURLWithPath:path1];
        
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        NSArray *temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        self.hospitalArray =(NSArray *)temp; //[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    return self;
}

@end
