//
//  QuicklyReplyViewController.m
//  妈妈问1
//
//  Created by lixuan on 15/3/16.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "QuicklyReplyViewController.h"
#import "Constant.h"
#import "QuickReplyModel.h"
#import "QuickReplyTableViewCell.h"
#import "HHTextView.h"
#import "NSString+CurrentTimeString.h"

#define kQuickReplyMsgidentify  @"kQuickReplyMsgidentify"

@interface QuicklyReplyViewController () <VoiceRecorderBaseVCDelegate>
{
    UIButton *_recordingBtn;
    
    HHTextView *_titleTextfield;
    BOOL _hasRecord;
    NSString *_recordTime;
}
@end

@implementation QuicklyReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制快捷回复";
    
    _hasRecord = NO;
    [self uiConfig];
    [self initializeRecordConfig];
//    NSLog(@"%@",[NSThread callStackSymbols]);
}
// 初始化播放VC
- (void)initializeRecordConfig {
    _recorderVC = [[ChatVoiceRecorderVC alloc] init];
    _recorderVC.vrbDelegate = self;
    
    
    // 初始化播放器
    _player = [[AVAudioPlayer alloc] init];
}
// UI
- (void)uiConfig {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(60, kScreenHeight * 2 / 5 - 50, kScreenWidth - 120, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
    
    _titleTextfield = [[HHTextView alloc] initWithFrame:CGRectMake(60, kScreenHeight * 2 / 5 - 40, kScreenWidth - 120, 30)];
    _titleTextfield.backgroundColor = [UIColor clearColor];
    _titleTextfield.placeHolder = @"输入自定义回复标题";
    _titleTextfield.font = [UIFont systemFontOfSize:iphone6? 16 : 12];
    _titleTextfield.textColor = [UIColor whiteColor];
    _titleTextfield.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleTextfield];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleTextfield.frame), CGRectGetMaxY(_titleTextfield.frame), CGRectGetWidth(_titleTextfield.frame), 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [self refrashButtons];
}
- (void)refrashButtons {
    for (UIView  *vv in self.view.subviews) {
        if (vv.tag == 1110 || vv.tag == 1111 || vv.tag == 1112 || vv.tag == 1113 || vv.tag == 1114) {
            [vv removeFromSuperview];
        }
    }
    
    if (_hasRecord) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.center.x - 40, CGRectGetMaxY(_titleTextfield.frame) + 60, 80, 40);
        btn.backgroundColor = [UIColor colorWithRed:0.18 green:1 blue:1 alpha:1];
        [btn addTarget:self action:@selector(playAudio) forControlEvents:64];
        btn.tag = 1111;
        [self.view addSubview:btn];
        
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame) + 2, CGRectGetMinY(btn.frame), 60, 40)];
        lable.text = _recordTime == nil? @"10''" : [NSString stringWithFormat:@"%@''",_recordTime];
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor clearColor];
        lable.tag = 1112;
        [self.view addSubview:lable];
        
        
        UIButton *reRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        reRecord.frame = CGRectMake(self.view.center.x -100, kScreenHeight - 50 - 50, 80, 50);
        reRecord.tag = 1113;
        reRecord.backgroundColor = [UIColor colorWithRed:0.16 green:0.82 blue:0.88 alpha:1];
        [reRecord setTitle:@"重录" forState:UIControlStateNormal];
        [reRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reRecord addTarget:self action:@selector(reRecord) forControlEvents:64];
        [self.view addSubview:reRecord];
        
        UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
        save.frame = CGRectMake(self.view.center.x + 100, CGRectGetMinY(reRecord.frame), CGRectGetWidth(reRecord.frame), CGRectGetHeight(reRecord.frame));
        save.backgroundColor = reRecord.backgroundColor;
        [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        save.tag = 1114;
        [save addTarget:self action:@selector(saveAudio) forControlEvents:64];
        [self.view addSubview:save];
    } else {
        UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recordBtn.frame = CGRectMake(self.view.center.x - 30, kScreenHeight - 180, 60, 60);
        recordBtn.layer.cornerRadius = 30;
        recordBtn.layer.masksToBounds = YES;
        recordBtn.tag = 1110;
        [recordBtn setImage:[UIImage imageNamed:@"16_03"] forState:UIControlStateNormal];
        [recordBtn addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
        [recordBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:recordBtn];
    }

}
- (void)beginRecord {
    // 设置文件名
    _originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    _convertAmr = [VoiceRecorderBaseVC getPathByFileName:_originWav ofType:@"amr"];
    _convertWav = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_rec",_originWav] ofType:@"amr"];
    // 开始录音
   
    [_recorderVC beginRecordByFileName:_originWav];
}
- (void)endRecord {
    [_recorderVC stopRecord];
    _hasRecord = YES;
    _recordTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"recordingTime"];
    [self refrashButtons];
    
}
- (void)reRecord {
   BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:_convertAmr error:nil];
    if (ret) {
        _hasRecord = NO;
        [self refrashButtons];
    }
}
- (void)saveAudio {
    if (_titleTextfield.text.length < 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请补充录音标题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self addModelDataWithTitle:_titleTextfield.text path:_originWav];
    [self backBarButtonItemClick];
}
#pragma mark -
#pragma mark 录音完成回调
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
    NSLog(@"录音完成，文件路径:%@",_filePath);
    BOOL convert = [VoiceConverter wavToAmr:_filePath amrSavePath:_convertAmr];
    if(convert == 0) [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];// 删除wav
    
}
- (void)addModelDataWithTitle:(NSString *)title path:(NSString *)path {
    QuickReplyModel *model = [[QuickReplyModel alloc] init];
    model.mesTitle = title;
    model.msgBody = path;
    model.msgTime = _recordTime;
    [self saveModelData:model];
    
}
//
- (void)saveModelData:(QuickReplyModel *)model {
    NSString *msgBody = model.msgBody;
    NSString *mesTitle = model.mesTitle;
    NSString *time = model.msgTime;
    NSDictionary *dic = @{@"msgBody":msgBody,@"msgTime":time};
    NSDictionary *d = [[NSUserDefaults standardUserDefaults] objectForKey:kQuickReplyMsgidentify];
    NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:d];
    [dd setObject:dic forKey:mesTitle];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kQuickReplyMsgidentify];
    [[NSUserDefaults standardUserDefaults] setObject:dd forKey:kQuickReplyMsgidentify];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)recording {
 
    _recordingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordingBtn.frame = CGRectMake(0, kScreenHeight , kScreenWidth, 40);
    [_recordingBtn setTitle:@"录 音" forState:UIControlStateNormal];
    _recordingBtn.backgroundColor = [UIColor grayColor];
    [_recordingBtn addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
    [_recordingBtn addTarget:self action:@selector(endRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordingBtn];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = _recordingBtn.frame;
        rect.origin.y -= 40;
        _recordingBtn.frame = rect;
    }];
}
- (void)playAudio {
    NSString  *playWavPath    = [[NSString getDocumentPathWithSuffixCompoment:[NSString getCurrentTimeString]] stringByAppendingString:@".wav"];
    [VoiceConverter amrToWav:[[NSString getDocumentPathWithSuffixCompoment:_originWav] stringByAppendingString:@".amr"] wavSavePath:playWavPath];
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
- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
}
- (void)backBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
