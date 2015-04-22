//
//  ChatViewController.h
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>
#import "VoiceRecorderBaseVC.h"
//#import "BaseViewController.h"
//#import "UITableView+TouchTableView.h"
@interface ChatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVAudioRecorderDelegate>
{
    UITableView *_tableView;
    
}
@property (nonatomic, strong) NSMutableArray *currentMessageArr;      //  缓存聊天数据（接收和发送的）
@property (nonatomic, strong) NSMutableArray *allMessageArr;          //  缓存的所有信息

@property (nonatomic, strong) UserModel *toUser;

@property (nonatomic, strong) ChatVoiceRecorderVC  *recorderVC;
@property (nonatomic, strong) AVAudioPlayer        *player;


//@property (retain, nonatomic) AVAudioPlayer        *audioPlayer;// 播放器，用于播放录音
@property (retain, nonatomic) AVAudioSession       *audioSession; // 音频会话
@property (retain, nonatomic) AVAudioRecorder      *recorder;     // 录音器
@property (assign, nonatomic) BOOL                 voiceInput;    // 用于“按住录音”按钮和输入文字的判断


@property (nonatomic, copy)   NSString             *originWav;   // 原始wav文件名
@property (nonatomic, copy)   NSString             *convertAmr;  // 转换后的amr
@property (nonatomic, copy)   NSString             *convertWav;  // 转换后的wav



@property (nonatomic, copy) NSString *firstStr;     //  提问vc传值str

@property (nonatomic, assign) BOOL    isHasPic;     // 问诊页面跳转时 内容是否包含图片
@property (nonatomic, strong) NSArray *picArr;      // 问诊页面跳转时 内容是否包含图片


@property (nonatomic, copy)  NSString *uid;      // userID
@property (nonatomic, copy)  NSString *sessionkey;
@property (nonatomic, assign)  NSInteger inquiryID;
@property (nonatomic, assign)  NSInteger patientID; // 患者id
@end
