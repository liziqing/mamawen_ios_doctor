//
//  QuickReplyListVC.m
//  妈妈问1
//
//  Created by kin on 15/4/8.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "QuickReplyListVC.h"
#import "Constant.h"
#import "QuickReplyTableViewCell.h"
#import "QuickReplyModel.h"
#import "NSString+CurrentTimeString.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
#import "QuicklyReplyViewController.h"

#define kQuickReplyMsgidentify  @"kQuickReplyMsgidentify"

@interface QuickReplyListVC () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    UIButton *_addBtn;
    NSInteger _selectIndex;
    
    AVAudioPlayer *_player;
}
@end

@implementation QuickReplyListVC
- (void)prepareData {
    if (!_dataArr) _dataArr = [[NSMutableArray alloc] init];
    
    [_dataArr removeAllObjects];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kQuickReplyMsgidentify];
    
    
    NSArray *keys = [dic allKeys];
    for (int i = 0; i < keys.count; i++) {
        
        QuickReplyModel *model = [[QuickReplyModel alloc] init];
        model.mesTitle = keys[i];
        model.msgBody = [dic[model.mesTitle] objectForKey:@"msgBody"];
        model.msgTime = [dic[model.mesTitle] objectForKey:@"msgTime"];
        [_dataArr addObject:model];
    }
    
    
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快捷回复";
    
    [self prepareData];
    [self uiConfig];
}
- (void)addAudio {
    QuicklyReplyViewController *vc = [[QuicklyReplyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)uiConfig {
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.frame = CGRectMake(45, kScreenHeight - 90, kScreenWidth - 90, 50);
    _addBtn.layer.cornerRadius = 5;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn setBackgroundColor:[UIColor colorWithRed:0.16 green:0.82 blue:0.88 alpha:1]];
    [_addBtn addTarget:self action:@selector(addAudio) forControlEvents:64];
    [_addBtn setTitle:@"添加自定义问题" forState:UIControlStateNormal];
    [self.view addSubview:_addBtn];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, CGRectGetMinY(_addBtn.frame) - 64 - 10) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *QuickReplyTableViewCellID = @"QuickReplyTableViewCellid";
    QuickReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuickReplyTableViewCellID];
    if (!cell) {
        cell = [[QuickReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuickReplyTableViewCellID];
    }
    cell.model = _dataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QuickReplyModel *model = _dataArr[indexPath.row];
    _selectIndex = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:model.mesTitle delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"试听",@"发送", nil];
    [alert show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    QuickReplyModel *model = _dataArr[_selectIndex];

        if (1 == buttonIndex) { // 试听
            [self playVideo];
        } else if (2 == buttonIndex) { // 发送 - 语音
            _selectMessage([NSData dataWithContentsOfFile:[[NSString getDocumentPathWithSuffixCompoment:model.msgBody] stringByAppendingString:@".amr"]],model.msgBody);
            [self.navigationController popViewControllerAnimated:YES];
        }
    
}
- (void)playVideo {

    QuickReplyModel *model = _dataArr[_selectIndex];
    NSString  *playWavPath    = [[NSString getDocumentPathWithSuffixCompoment:[NSString getCurrentTimeString]] stringByAppendingString:@".wav"];
    [VoiceConverter amrToWav:[[NSString getDocumentPathWithSuffixCompoment:model.msgBody] stringByAppendingString:@".amr"] wavSavePath:playWavPath];
    NSData *wavData = [NSData dataWithContentsOfFile:playWavPath];
    if (!_player) {
        _player = [[AVAudioPlayer alloc] init];
    }
    _player = [_player initWithData:wavData error:nil];
    _player.volume = 8;
    [_player prepareToPlay];
    [_player play];
    [[NSFileManager defaultManager] removeItemAtPath:playWavPath error:nil];

}
- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backimage.jpg"]];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backimage.jpg"]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 5, 32, 32);
    btn.layer.cornerRadius = 16;
    btn.layer.masksToBounds = YES;
    [btn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBarButtonItemClick) forControlEvents:64];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    
    self.tabBarController.tabBar.hidden = YES;
    
    
    [self prepareData];
}
- (void)backBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
