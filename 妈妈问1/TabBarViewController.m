//
//  TabBarViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/14.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "TabBarViewController.h"

static TabBarViewController *tablevc;

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+(TabBarViewController *)sharetablevc{
    
    static dispatch_once_t once;
       dispatch_once(&once, ^{
        tablevc= [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"tabBarView"];
            });
            return tablevc;
    
}

@end
