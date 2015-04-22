//
//  QuicklyReplyViewController.h
//  妈妈问1
//
//  Created by lixuan on 15/3/16.
//  Copyright (c) 2015年 netshow. All rights reserved.
//



// 快速回复 -- 录音界面
#import <UIKit/UIKit.h>
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceRecorderBaseVC.h"


@interface QuicklyReplyViewController : UIViewController <AVAudioRecorderDelegate>

@property (nonatomic, strong) ChatVoiceRecorderVC  *recorderVC;
@property (nonatomic, strong) AVAudioPlayer        *player;
@property (retain, nonatomic) AVAudioSession       *audioSession; // 音频会话
@property (retain, nonatomic) AVAudioRecorder      *recorder;     // 录音器

@property (nonatomic, copy)   NSString             *originWav;   // 原始wav文件名
@property (nonatomic, copy)   NSString             *convertAmr;  // 转换后的amr
@property (nonatomic, copy)   NSString             *convertWav;  // 转换后的wav   --  用于播放  存wav太占内存
@property (nonatomic, copy)   NSString             *playWavPath;





@end
