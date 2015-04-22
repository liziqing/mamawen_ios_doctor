//
//  FriendListViewController.h
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

}
@property (nonatomic, strong) NSMutableArray *friendListArr;
@end
