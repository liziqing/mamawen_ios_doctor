//
//  FriendListViewController.m
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "FriendListViewController.h"
#import "LXXMPPManager.h"
#import "UserModel.h"
#import "ChatViewController.h"
@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"朋友";
    _friendListArr = [NSMutableArray array];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [[LXXMPPManager shareXMPPManager] getAllFriends:
     ^(NSArray *list) {
         [_friendListArr removeAllObjects];
         [_friendListArr addObjectsFromArray:list];
         [_tableView reloadData];
     }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"friendCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UserModel *um = [_friendListArr objectAtIndex:indexPath.row];
    if ([um isOnline]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text = um.jid;
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    
    UserModel *um = _friendListArr[indexPath.row];
    chatVC.toUser = um;
    chatVC.title = um.jid;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
