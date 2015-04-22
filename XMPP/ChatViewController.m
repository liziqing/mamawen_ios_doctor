//
//  ChatViewController.m
//  chatdemo
//
//  Created by lixuan on 15/2/4.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import "ChatViewController.h"
#import "LXXMPPManager.h"
#import "MessageModel.h"
#import "NSData+Base64.h"
#import "CustomRoundnessButton.h"
#import "HHTextView.h"

#import "Constant.h"

#import "QuickReplyListVC.h"
#import "EndPrediagnosisViewController.h"

#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"

#import "DBManager.h"
#import "UserInfo.h"
#import "NSString+CurrentTimeString.h"
//--------------------------xu-----
#import"CaseViewController.h"
//---------------------------xu----


#import "EndPrediagnosisView.h"
#define SPACING_MIN   5.0

@interface ChatViewController () <VoiceRecorderBaseVCDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_cacheVideosArr;
    UIView *_toolBar;      // 对话框等  toolbar功能满足不了   用UIView自定义
    CustomRoundnessButton *_statusBtn;     // 切换语音状态按钮
    UIButton *_talkBtn;       // 语音按钮
    CustomRoundnessButton *_addBtn;        // 加号按钮
    CustomRoundnessButton *_giftBtn;       // 礼物按钮
    HHTextView *_textView;                 //
    CGRect _tbRect;
    CGRect _originalToolbarRect;
    UIView *_moreBackView;                 // 更多背景视图
    
    
    BOOL _isKeyBoard;
    
    BOOL _isSendTextMessage;              //
    BOOL _isbeginVoiceRecord;              //
    
    NSString *_receiveAmrPath;             // 收到的amr文件路径  存储
    NSString *_playWavPath;                // 用于播放的wav路径  需删除
    
    UIImageView *_bigImgVBack;                     // 点击小图  显示大图
}


@end

@implementation ChatViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)_initializeRecordConfig {
    _recorderVC = [[ChatVoiceRecorderVC alloc] init]; // 初始化播放VC
    _recorderVC.vrbDelegate = self;
    
    
    // 初始化播放器
    _player = [[AVAudioPlayer alloc] init];
    _voiceInput = NO;
   
    // 拿到缓存的所有video 数组
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, YES)[0];
    _cacheVideosArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    for (id obj in _cacheVideosArr) {
        NSLog(@"%@",obj);
    }
    
}
// 医生端用
// 创建点击‘+’后弹出的更多按钮
- (void)createMoreButtons {
    NSArray *titlesArr = @[@"照片",@"拍摄",@"快捷回复",@"完成预诊",@"查看病例",@"设置提醒"];
    NSArray *imgsArr = @[@"15_03",@"15_06",@"15_08",@"15_10",@"15_16",@"15_17"];
    CGFloat w = (kScreenWidth - 105)/4 ;
    for (int i = 0; i < titlesArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30 + (w + 15) * (i % 4), 15 + (w + 40) * (i / 4), w, w);
        btn.layer.cornerRadius = w / 2;
        btn.layer.masksToBounds = YES;
        [btn setImage:[UIImage imageNamed:imgsArr[i]] forState:UIControlStateNormal];
        btn.tag = 220 + i;
        [btn addTarget:self action:@selector(myInputViewButtonsClick:) forControlEvents:64];
        [_moreBackView addSubview:btn];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), CGRectGetMaxY(btn.frame) + 10, btn.frame.size.width, 10)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = titlesArr[i];
        lable.font = [UIFont systemFontOfSize:14];
        lable.adjustsFontSizeToFitWidth = YES;
        lable.textColor = [UIColor whiteColor];
        [_moreBackView addSubview:lable];
    }
}
- (void)myInputViewButtonsClick:(UIButton *)btn {
    NSInteger index = btn.tag - 220;
    switch (index) {
        case 0: // 打开图库
            [self openPicLibrary];
            break;
        case 1:// 打开相机
            [self addCamera];
            break;
        case 2:// 快速回复
            [self quicklyReply];
            break;
        case 3:// 完成预诊
            [self completeInquiry];
            break;
        case 4:// 查看病例
            [self checkCase];
            break;
        case 5:// 设置提醒
            [self setNotice];
            break;
//        case 6:// 加号
//            [self addInquiryNumber];
//            break;
//        case 7:// 免费电话
//            [self freePhone];
//            break;
        default:// 没了
            break;
    }
    [self.view endEditing:YES];
}
// 初始化toolbar
- (void)createToolbar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64)];
    
    
    CGFloat width = _toolBar.frame.size.height - 10 -20;
    
    
    _statusBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(SPACING_MIN * 2, SPACING_MIN + 10, width, width)];
    [_statusBtn setImage:[UIImage imageNamed:@"14_07"] forState:UIControlStateNormal];
    [_statusBtn addTarget:self action:@selector(statusBtnClick) forControlEvents:64];
    [_toolBar addSubview:_statusBtn];
    
    
    _talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, SPACING_MIN + 10, kScreenWidth - 70 * 2, width)];
    [_talkBtn setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
    [_talkBtn setTitle:@"Hold to Talk" forState:UIControlStateNormal];
    [_talkBtn setTitle:@"Release to Send" forState:UIControlStateHighlighted];
    _talkBtn.hidden = YES;
    [_talkBtn addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchDown];
    [_talkBtn addTarget:self action:@selector(stopTalk) forControlEvents:64];
    _talkBtn.layer.cornerRadius = 8;
    _talkBtn.layer.borderWidth = 2;
    _talkBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_toolBar addSubview:_talkBtn];
    
    
    _textView = [[HHTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_statusBtn.frame) + SPACING_MIN * 2, SPACING_MIN + 10, kScreenWidth - width * 3, width)];
    _textView.placeHolder = @" 输入你想回复的内容";
    _textView.delegate = self;
    _textView.layer.cornerRadius = 8;
    _textView.keyboardType = UIKeyboardTypeNamePhonePad;
   [_toolBar addSubview:_textView];
    
//    _giftBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + SPACING_MIN, SPACING_MIN, width, width)];
//    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:_giftBtn];
    
    
    _addBtn = [[CustomRoundnessButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textView.frame) + SPACING_MIN , SPACING_MIN + 10, width, width)];
    [_addBtn addTarget:self action:@selector(moreSelectorBtnClick) forControlEvents:64];
    [_addBtn setImage:[UIImage imageNamed:@"14_09"]  forState:UIControlStateNormal];
    _addBtn.layer.cornerRadius = width / 2;
    _addBtn.layer.masksToBounds = YES;
    _addBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addBtn.layer.borderWidth = 1;
    [_toolBar addSubview:_addBtn];
   
    
    
    
    [_toolBar setBackgroundColor:[UIColor colorWithRed:0.45 green:0.53 blue:0.74 alpha:1]];
    [self.view addSubview:_toolBar];
    _originalToolbarRect = _toolBar.frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 

    self.title = @"预诊";
    _isSendTextMessage = NO;
    [self  _initializeRecordConfig];

    // 测试  制定账号发送
    if (!_toUser) {
        _toUser = [[UserModel alloc] init];
    _toUser.jid = @"test3@182.254.222.156";
    }
    
    
    if (!_uid) {
        UserInfo *user = [UserInfo sharedUserInfo];
        _uid = user.userID;
    }
    UserInfo *info = [UserInfo sharedUserInfo];
    _firstStr = [NSString stringWithFormat:@"%@医生问您接诊",info.userName];
    
    
    // 取数据
    if ([[DBManager sharedManager] isExists:[NSString stringWithFormat:@"%ld",(long)_inquiryID]]) {
        _allMessageArr =  [[NSMutableArray alloc] init];
        NSMutableArray *arr =  [[DBManager sharedManager] fetchAll];
        for (MessageModel *model in arr) {
            if ([model.messageId isEqualToString:[NSString stringWithFormat:@"%ld",(long)_inquiryID]]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:model forKey:model.toOrFrom];
                [_allMessageArr addObject:dic];
                _currentMessageArr = _allMessageArr;
            }
        }
    } else {
        _currentMessageArr = [NSMutableArray array]; // 消息数组  如果本地已有消息，则加入此数组即可
//        [self saveMessage:_firstStr WithMode:kMessageToUser];
        [[LXXMPPManager shareXMPPManager] sendMessage:_firstStr withType:chatModeString senderID:_uid.integerValue senderRole:chatRoleDoctor receiveID:_patientID receiveRole:chatRolePatient chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
            
        }];
        [self saveMessage:_firstStr withToOrFromMode:kMessageToUser chatmode:chatModeString chatCategory:chatCatagoryNormal];
    }
   
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64
) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    

    // 接收信息
    [[LXXMPPManager shareXMPPManager] registerForMessage:^(MessageModel *oneMessage){
//        [self saveMessage:oneMessage WithMode:kMessageFormUser];
        if ([oneMessage.messageId isEqualToString:[NSString stringWithFormat:@"%ld",(long)_inquiryID]]) {
             [self saveMessage:oneMessage withToOrFromMode:kMessageFormUser chatmode:chatModeNone chatCategory:chatCatagoryNormal];
            [self scrollToBottom];
            _patientID = oneMessage.patientID;
        }
    }];
     [self createToolbar];
//     [_tableView reloadData];
     [self scrollToBottom];
}

- (void)talk {
    // 设置文件名
    _originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    _convertAmr = [VoiceRecorderBaseVC getPathByFileName:_originWav ofType:@"amr"];
    _receiveAmrPath = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_rec",_originWav] ofType:@"amr"];
    _playWavPath    = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_play",_originWav] ofType:@"wav"];
    
    // 开始录音
    [_recorderVC beginRecordByFileName:_originWav];
}

- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString*)_fileName{
//    NSLog(@"录音完成，文件路径:%@",_filePath);
    BOOL convert = [VoiceConverter wavToAmr:_filePath amrSavePath:_convertAmr];
    if(convert == 0) [[NSFileManager defaultManager] removeItemAtPath:_filePath error:nil];// 删除wav
    NSData *data = [NSData dataWithContentsOfFile:_convertAmr];
    [self sendVoiceWithData:data];
    [self scrollToBottom];
}
- (void)stopTalk {
    [_recorderVC stopRecord];
}
- (void)sendMessage {
    if (_textView.text == nil || [_textView.text  isEqual: @""]) {
        [self showAlertViewWithMessage:@"发送内容不能为空，请输入你想发送的文字"];
        return;
    }
    NSString *mes = _textView.text;
    
    [self sendMessageTextWithMes:mes];
    [self scrollToBottom];
    _textView.text = nil;
    [self changeSendBtnWithPhoto:YES];
}

- (void)sendMessageTextWithMes:(NSString *)mes {
//    NSLog(@"inquiryID:%ld  patientID:%ld,uid:%@",_inquiryID,_patientID,_uid);
    [[LXXMPPManager shareXMPPManager] sendMessage:mes withType:chatModeString senderID:_uid.integerValue senderRole:chatRoleDoctor receiveID:_patientID receiveRole:chatRolePatient chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if (ret) {
            NSLog(@"发送文字成功");
            [self scrollToBottom];
//            [self saveMessage:mes WithMode:kMessageToUser];
            [self saveMessage:mes withToOrFromMode:kMessageToUser chatmode:chatModeString chatCategory:chatCatagoryNormal];
        } else {
        }
    }];
    
    [_textView resignFirstResponder];
}

- (void)sendPicture:(UIImage *)img {
//    NSData *data = UIImagePNGRepresentation(img);
    NSData *data = UIImageJPEGRepresentation(img, 0.75);
  
    [[LXXMPPManager shareXMPPManager] sendMessage:data withType:chatModePicture senderID:_uid.integerValue senderRole:chatRoleDoctor receiveID:_patientID receiveRole:chatRolePatient chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if(ret)  NSLog(@"图片发送完成");
        else     NSLog(@"图片发送失败");
    }];
      [self scrollToBottom];
    
    // 保存图片路径
    NSString *timeStr = [NSString getCurrentTimeString];
    if ([data writeToFile:[[NSString getDocumentPathWithSuffixCompoment:timeStr] stringByAppendingString:@"_pic"] atomically:YES]) {
        [self saveMessage:[timeStr stringByAppendingString:@"_pic"] withToOrFromMode:kMessageToUser chatmode:chatModePicture chatCategory:chatCatagoryNormal];
    }
}
- (void)sendVoiceWithData:(NSData *)data {
//    NSString *recordPath = [VoiceRecorderBaseVC getPathByFileName:_convertAmr ofType:@"amr"];
    
//    NSLog(@"---%@---",data); // 2321414d 520a3c6a f86a3842 318188ec c1dcf651
    
  /*
   int char1 = 0,char2 = 0;
    [data getBytes:&char1 range:NSMakeRange(0, 1)];
    [data getBytes:&char2 range:NSMakeRange(1, 1)];
    NSLog(@"%d--%d",char1,char2);
    
    NSString *str = [NSString stringWithFormat:@"%i%i",char1,char2];
    NSLog(@"video ---%@",str); // 3533
    */
    
//    NSString *dataBase64 = [data base64EncodedString];
    

    
    [[LXXMPPManager shareXMPPManager] sendMessage:data withType:chatModeVideo senderID:_uid.integerValue senderRole:chatRoleDoctor receiveID:_patientID receiveRole:chatRolePatient chatCatagory:chatCatagoryNormal inquiryID:_inquiryID withCompletion:^(BOOL ret) {
        if (ret) NSLog(@"发送语音成功");
        else NSLog(@"发送语音失败");
    }];
    [self scrollToBottom];
  
    [self saveMessage:[_originWav stringByAppendingString:@".amr"] withToOrFromMode:kMessageToUser chatmode:chatModeVideo chatCategory:chatCatagoryNormal];
}
#pragma  mark -
#pragma  mark ActionSheet delegate  && 相机 && 图库
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 0) {
//        [self addCamera];
//    } else if (buttonIndex == 1) {
//        [self openPicLibrary];
//    }
//
//}
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        
        }];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)openPicLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *editImage = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self sendPicture:editImage];
        [self scrollToBottom];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 快速回复
- (void)quicklyReply {
    QuickReplyListVC *VC = [[QuickReplyListVC alloc] init];
//    QuickReplyViewController *VC = [[QuickReplyViewController alloc] init];
    
    [VC setSelectMessage:^(NSData *data, NSString *path) {
                _originWav = path;
        [self sendVoiceWithData:data];
        [self scrollToBottom];
    }];
    [self.navigationController pushViewController:VC animated:YES];
}
// 完成预诊
- (void)completeInquiry {
    EndPrediagnosisViewController *vc = [[EndPrediagnosisViewController alloc] init];
    vc.title = @" 填写预诊信息";
    
    
    
    NSDictionary *dic = @{@"sr":@(chatRoleDoctor),@"rid":@(_patientID),@"rr":@(chatRolePatient),@"category":@(chatCatagoryPrediagnosisReport),@"inquiry":@(_inquiryID)};
    vc.mesInfoDic = dic;
    
    [vc setPatientInfoCB:^(NSDictionary *infoDic ,NSDictionary *mesInfo) {
        NSString *problem = infoDic[@"problem"];
        NSString *suggest = infoDic[@"suggest"];
        UserInfo *info = [UserInfo sharedUserInfo];
        _uid = info.userID;
//        [self sendMessageTextWithMes:[NSString stringWithFormat:@"[问诊结束]问题：%@   建议：%@",problem,suggest]];
        
        [[LXXMPPManager shareXMPPManager] sendMessage:infoDic withType:chatModeNone senderID:_uid.integerValue senderRole:[mesInfo[@"sr"] integerValue] receiveID:[mesInfo[@"rid"] integerValue] receiveRole:[mesInfo[@"rr"] integerValue] chatCatagory:[mesInfo[@"category"] integerValue] inquiryID:[mesInfo[@"inquiry"] integerValue] withCompletion:^(BOOL ret) {
            if (ret) {
                NSLog(@"发送报告成功");
            }
        }];
        
#warning 结束预诊发送信息
//        NSLog(@"需要发送的预诊结束信息: problem:%@,suggest:%@",problem,suggest);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer  = [AFJSONRequestSerializer serializer];
        NSMutableDictionary *para = [NSMutableDictionary dictionary];
        [para setObject:@(_inquiryID) forKey:@"inquiryID"];
        [para setObject:problem forKey:@"description"];
        [para setObject:suggest forKey:@"suggestion"];
        
        
        // 发起请求
        [manager POST:[@"http://115.159.49.31:9000" stringByAppendingString:[NSString stringWithFormat:@"/doctor/inquiry/report?uid=%@&sessionkey=%@",_uid,_sessionkey]] parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            NSLog(@"post severce sucess");
            [self saveMessage:@{@"problem":problem,@"suggest":suggest} withToOrFromMode:kMessageToUser chatmode:chatModeNone chatCategory:chatCatagoryPrediagnosisReport];
            [self scrollToBottom];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"post severce faild with error:%@",error.description);
        }];
        
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
// 查看病例
- (void)checkCase {
    //----------------xu------------
    
    
    CaseViewController *caseview=[[CaseViewController alloc]init];
    caseview.paitientuid=self.uid;
    //caseview.askID=self.inquiryID;
    
    [self.navigationController pushViewController:caseview animated:YES];
    
        
    //--------------xu-----------
    
    

}
// 设置提醒
- (void)setNotice {

}
// 加号
- (void)addInquiryNumber {

}
// 免费电话
- (void)freePhone {

}
#pragma mark -
#pragma mark 改变发送按钮
- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    _isSendTextMessage = !isPhoto;
    if (!isPhoto) {
        [_addBtn setImage:nil forState:UIControlStateNormal];
    } else{
    [_addBtn setImage:[UIImage imageNamed:@"14_09"]  forState:UIControlStateNormal];
    }
    [_addBtn setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark toolbar 按钮事件
- (void)moreSelectorBtnClick { // 用户板   相机按钮

    if (_isSendTextMessage) {
        _moreBackView.hidden = YES;
        _textView.inputView = nil;
        [self sendMessage];
    } else {
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images", nil];
//        [actionSheet showInView:self.view.window];
            _isKeyBoard = !_isKeyBoard;
            if (!_isKeyBoard) {
                _moreBackView.hidden = YES;
                _textView.inputView = nil;
            } else {
                CGFloat height = kScreenHeight / 3;
                if (_moreBackView != nil) {
                    _moreBackView.hidden = NO;
                } else {
                _moreBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - height, kScreenWidth, height)];
                _moreBackView.backgroundColor = [UIColor colorWithRed:0.51 green:0.67 blue:0.9 alpha:1];
                    [self createMoreButtons];
                }
        
                _textView.inputView = _moreBackView;
            }
            [_textView resignFirstResponder];
            [_textView becomeFirstResponder];
    }
    
}
- (void)statusBtnClick {
    _talkBtn.hidden = !_talkBtn.hidden;
    _textView.hidden  = !_textView.hidden;
    _isbeginVoiceRecord = !_isbeginVoiceRecord;
    if (_isbeginVoiceRecord) {
        [_statusBtn setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [_textView resignFirstResponder];
    }else{
        [_statusBtn setImage:[UIImage imageNamed:@"14_07"] forState:UIControlStateNormal];
        [_textView becomeFirstResponder];
    }
}
#pragma mark -
#pragma mark 键盘高度变化
- (void)chatKeyboardFrameChange:(NSNotification *)aNotification {
    _tbRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changToolbarAndTableviewPositionWithKeyboardPosition:NO];
}
- (void)chatKeyboardWillhide:(NSNotification *)bNotification {
     _tbRect = [[bNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self changToolbarAndTableviewPositionWithKeyboardPosition:YES];
}
- (void)changToolbarAndTableviewPositionWithKeyboardPosition:(BOOL)isHidden {
    [UIView animateWithDuration:0.35 animations:^{
        CGRect rect = _toolBar.frame;
        rect.origin.y = _tbRect.origin.y - rect.size.height;
        _toolBar.frame = rect;
        if (isHidden) {
            _tableView.contentInset = UIEdgeInsetsMake(64, 0, kScreenHeight - CGRectGetMinY(_toolBar.frame) - CGRectGetHeight(_toolBar.frame), 0);
        } else {
        _tableView.contentInset = UIEdgeInsetsMake(64, 0,_tableView.frame.size.height - _tbRect.origin.y + CGRectGetHeight(_toolBar.frame) , 0);
        }
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
}

#pragma mark -
#pragma mark textview delegate

- (void)textViewDidChange:(UITextView *)textView {
    [self changeSendBtnWithPhoto:textView.text.length > 0?NO : YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (1 == range.length) { //  按下回格键
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark  触摸事件
//触摸取消textview的第一响应者   被tableview覆盖   待改进
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}


#pragma mark -
#pragma mark 滚动tableview   与自动滚动冲突  待改进
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == _tableView) {
//        [_textView resignFirstResponder];
//    }
//}

#pragma mark -
#pragma mark 弹窗
- (void)showAlertViewWithMessage:(NSString *)mes {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:mes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark -
#pragma mark 滚动到最新一条聊天数据
- (void)scrollToBottom {
      [_tableView reloadData];
    if (_currentMessageArr.count == 0) {
        return;
    }
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentMessageArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
   
}

#pragma mark -
#pragma mark 聊天数据缓存
- (void)saveMessage:(id)oneMessage WithMode:(NSString *)mode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([oneMessage isKindOfClass:[MessageModel class]]) {
        [(MessageModel *)oneMessage setToOrFrom:mode];
        [(MessageModel *)oneMessage setMessageId:_toUser.jid];
        [dict setObject:oneMessage forKey:mode];
        if ([mode isEqualToString:kMessageToUser]) {
            [[DBManager sharedManager] insertModel:oneMessage];
        }
    } else {
        MessageModel *Msg = [[MessageModel alloc] init];
        Msg.message = oneMessage;
        Msg.toOrFrom = mode;
        Msg.messageId = _toUser.jid;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *da = [[NSDateFormatter alloc] init];
        [da setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [da stringFromDate:date];
        
        Msg.mesTime = timeStr;
        [dict setObject:Msg forKey:mode];
        if ([mode isEqualToString:kMessageToUser]) {
            [[DBManager sharedManager] insertModel:Msg];
        }
    }
    [_currentMessageArr addObject:dict];
    [self scrollToBottom];
}

- (void)saveMessage:(id)oneMessage withToOrFromMode:(NSString *)mode chatmode:(chatMode)cmode chatCategory:(chatCatagory)category {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([oneMessage isKindOfClass:[MessageModel class]]) {
        //        [(MessageModel *)oneMessage setToOrFrom:mode];
        //        [(MessageModel *)oneMessage setMessageId:[NSString stringWithFormat:@"%ld", (long)_inquiryID ]];
        [dict setObject:oneMessage forKey:mode];
        
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {
                
            } else
                [[DBManager sharedManager] insertModel:oneMessage];
        }
        
    } else {
        MessageModel *Msg = [[MessageModel alloc] init];
        if (category == chatCatagoryPrediagnosisReport) {
            Msg.reportDic = (NSDictionary *)oneMessage;
            
        } else {
            Msg.messageBody = oneMessage;
        }
        Msg.toOrFrom = mode;
        Msg.messageId = [NSString stringWithFormat:@"%ld", (long)_inquiryID ];
        Msg.senderid = _uid.integerValue;
        Msg.senderrole = chatRolePatient;
        Msg.receiveid = _patientID;
        Msg.receiverole = chatRoleDoctor;
        Msg.patientID = _patientID;
        Msg.inquiryID = _inquiryID;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *da = [[NSDateFormatter alloc] init];
        [da setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *timeStr = [da stringFromDate:date];
        
        Msg.mesTime = timeStr;
        Msg.cmode = cmode;
        Msg.ccategory = category;
        
        [dict setObject:Msg forKey:mode];
        if ([mode isEqualToString:kMessageToUser]) { // 接收的在manager中已缓存
            if (!_inquiryID) {
                
            } else
                [[DBManager sharedManager] insertModel:Msg];
        }
    }
    [_currentMessageArr addObject:dict];
    [self scrollToBottom];
}
- (void)viewWillDisappear:(BOOL)animated {
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 1, YES)[0];
    // 写入本地 或 发送服务器
//    NSLog(@"%@",path);
    
    
//    [(RootTabbarController *)self.tabBarController hiddenMyTabbar:NO];
}


#pragma mark -
#pragma mark 隐藏tabbar && 添加键盘通知
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
- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardFrameChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatKeyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
#pragma mark -
#pragma mark tableView  Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentMessageArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dic allValues][0];
    
    if (_currentMessageArr.count == 1) {
        mm.isFirstMes = YES;
    }
    CGFloat cellHeight = 0.0;
    if (mm.cmode == chatModeString) {  // 文字
         NSString *str = mm.messageBody;
     CGSize size = [str boundingRectWithSize:CGSizeMake(200, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        cellHeight = mm.isShowTime? size.height + 50 + 20 + 20 : size.height + 50 + 20;
    }   else if (mm.cmode == chatModeVideo) {            //   语音
        cellHeight = mm.isShowTime? 40 + 40 + 20 : 40 + 40;
    }   else {                              // 图片
//        return mm.image.size.height + 10;
        cellHeight = mm.isShowTime? 240 + 20 + 20 : 240 + 20;
    }
    
//    if (indexPath.row == 0 && YES == _isHasPic ) {
//        cellHeight += 70;
//    }
//    if (indexPath.row == 1) {
//        cellHeight +=20;
//    }
//    NSString *str = mm.message;
    if (mm.ccategory == chatCatagoryPrediagnosisReport) {
        cellHeight = 303;
    }
    if (mm.ccategory == chatCatagoryFindDr) {
        NSString *str = mm.messageBody;
        CGSize size = [str boundingRectWithSize:CGSizeMake(200, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        cellHeight = mm.isShowTime? size.height + 50 + 20 + 20 : size.height + 50 + 20;
    }

    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"friendCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //清除上一次的视图
    for(UIView *view in cell.contentView.subviews){
        
        if(view.tag==1001 || view.tag==1002 || view.tag == 1004 || view.tag ==1005 || view.tag == 1006 || view.tag == 1007 || view.tag == 1008 || view.tag == 1009)
            [view removeFromSuperview];
    }
    
    //头像
    UIImageView *headImgV = [[UIImageView alloc]init];
    headImgV.layer.cornerRadius = 7;
    headImgV.layer.masksToBounds = YES;
    headImgV.tag=1001;
    //气泡
    UIImageView *chatBackGroundImgV = [[UIImageView alloc]init];
    chatBackGroundImgV.tag=1002;
    // 图片
    UIImageView *pic = [[UIImageView alloc]init];
    pic.tag=1004;
    //文字
    UILabel *label = [[UILabel alloc]init];
    label.tag=1003;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    // time lable
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.tag = 1005;
    timeLable.numberOfLines = 1;
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.font = [UIFont systemFontOfSize:12];
    timeLable.textColor = [UIColor whiteColor];
    
    
    // 用户端显示用   医生端不用
    
    // 第一条信息 提示lable
    UILabel *noticeLable = [[UILabel alloc] init];
    noticeLable.tag = 1006;
    noticeLable.numberOfLines = 1;
    noticeLable.textAlignment = NSTextAlignmentCenter;
    noticeLable.font = [UIFont systemFontOfSize:12];
    noticeLable.textColor = [UIColor whiteColor];
//
//    
//    // 第一条信息 提示lable
//    UILabel *hintLable = [[UILabel alloc] init];
//    hintLable.tag = 1007;
//    hintLable.numberOfLines = 1;
//    hintLable.textAlignment = NSTextAlignmentCenter;
//    hintLable.font = [UIFont systemFontOfSize:12];
//    hintLable.textColor = [UIColor whiteColor];
//    
//    UIImageView *imgVBackView = [[UIImageView alloc] init];
//    imgVBackView.userInteractionEnabled = YES;
//    imgVBackView.tag = 1008;
//    imgVBackView.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dict allValues][0];
    
    

    
    CGSize size;
    if (mm.cmode == chatModeString || mm.ccategory == chatCatagoryFindDr) {
        NSString *str = mm.messageBody;
        size = [str boundingRectWithSize:CGSizeMake(200, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    } else if (mm.cmode == chatModeVideo) {
        size = CGSizeMake(kScreenWidth / 3, 5);
    } else size = CGSizeMake(180, 240);
    
    
    
    label.text = mm.messageBody;
    label.frame = CGRectMake(20, 3, size.width + 20, size.height + 40);

    
    
    CGFloat width;
    if ([[dict allKeys][0] isEqualToString:kMessageToUser]) { // 发
//        headImgV.frame = CGRectZero;
        headImgV.image = [UIImage imageNamed:@"1.jpg"];
        headImgV.frame = CGRectMake(kScreenWidth - 50 - 5, 25 + iphone6? 25 : 22, 50, 50);
        headImgV.layer.cornerRadius = headImgV.frame.size.width / 2;

        chatBackGroundImgV.image = [UIImage imageNamed:@"chatto_bg_normal"];
//        chatBackGroundImgV.frame = CGRectMake(kScreenWidth  - size.width - 60 - 2, 20,size.width + 60 , size.height + 50);
//        width = 10.0;
        
        // 时间lable
//        timeLable.frame = CGRectMake(0, 20, 60, 40);
        chatBackGroundImgV.frame = CGRectMake(kScreenWidth  - size.width - 60 - 2 - 35, 20,size.width  + 40, size.height + 50);
        width = 10.0;
        
        
        label.frame = CGRectMake(8, 3, size.width + 20, size.height + 40);


    }
    else { // 收
        headImgV.image = [UIImage imageNamed:@"0.jpg"];
        headImgV.frame = CGRectMake(5, iphone6? 25 : 22, 50, 50);
        headImgV.layer.cornerRadius = headImgV.frame.size.width / 2;
        chatBackGroundImgV.image = [UIImage imageNamed:@"chatfrom_bg_normal"];
        chatBackGroundImgV.frame = CGRectMake(62, 20,size.width + 60 , size.height + 50);
       width = 20.0;
        
        // 时间lable
//        timeLable.frame = CGRectMake(kScreenWidth - 60, 20, 60, 40);
    }
    
    
    if (YES == mm.isFirstMes) {
//        if (_isHasPic && _picArr.count != 0) {
//            imgVBackView.frame = CGRectMake(0, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth, 60);
//            for (int i = 0; i < _picArr.count; i ++) {
//                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(50 + 70 * i, 0, 60, 60)];
//                imgV.layer.cornerRadius = 5;
//                imgV.layer.masksToBounds = YES;
//                imgV.image = _picArr[i];
//                imgV.userInteractionEnabled = YES;
//                imgV.tag = 120 + i;
//                [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inquiryImageTap:)]];
//                [imgVBackView addSubview:imgV];
//            }
//        }
//        
//        
//        if (_isHasPic)  noticeLable.frame = CGRectMake(0, CGRectGetMaxY(imgVBackView.frame) + 5, kScreenWidth, 15);
//         else
             noticeLable.frame = CGRectMake(0, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth, 15);
//
        noticeLable.text = @" 接诊成功， 现在可以回答患者的提问了";
//
//      
//    }
    
//    if (indexPath.row == 1) {
//        hintLable.frame = CGRectMake(0, CGRectGetMaxY(chatBackGroundImgV.frame) + 5, kScreenWidth, 15);
//        hintLable.text = @"医生使用休息时间为您预诊的，如未能及时回复，还请见谅";
    }
    
    if (mm.isShowTime) { // 是否显示时间
        NSString *timeStr = [mm showTime];
        CGSize size = [timeStr boundingRectWithSize:CGSizeMake(kScreenWidth / 2, 10) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size;
        timeLable.frame = CGRectMake(0, 10, size.width  + 10, 15);
        timeLable.center = CGPointMake(self.view.center.x, 10);
//        timeLable.backgroundColor = [UIColor lightGrayColor];
        timeLable.layer.cornerRadius = 3;
        timeLable.layer.masksToBounds = YES;
        timeLable.text = timeStr;
    }
//    NSLog(@"接收时间:%@",[mm showTime]);
    
    CGFloat top = 50; // 顶端盖高度
    CGFloat bottom = 50 ; // 底端盖高度
    CGFloat left = 50; // 左端盖宽度
    CGFloat right = 50; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    chatBackGroundImgV.image = [chatBackGroundImgV.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    cell.backgroundColor = [UIColor clearColor];
    [chatBackGroundImgV addSubview:label];
    [cell.contentView addSubview:chatBackGroundImgV];
    [cell.contentView addSubview:headImgV];
    [cell.contentView addSubview:timeLable];
    if (indexPath.row == 0) [cell.contentView addSubview:noticeLable];
//    if (indexPath.row == 1) [cell.contentView addSubview:hintLable];
//    if (indexPath.row == 0) [cell.contentView addSubview:imgVBackView];
    [chatBackGroundImgV addSubview:pic];

    
    if (mm.cmode == chatModePicture) {          // 图片
        label.text = nil;
        CGRect rect =  chatBackGroundImgV.frame;
        rect.size.width = 240;
        rect.size.height = 240;
        chatBackGroundImgV.frame = rect;
        pic.frame = CGRectMake(5 + width, 12, chatBackGroundImgV.frame.size.width - 40, chatBackGroundImgV.frame.size.height - 30);
        
        
        if ([mm.toOrFrom  isEqual: kMessageFormUser]) {
            [pic setImageWithURL:[NSURL URLWithString:[@"http://115.159.49.31:9000" stringByAppendingString:mm.messageBody]] placeholderImage:[UIImage imageNamed:@"04_10.png"]];
        } else {
            pic.image = [UIImage imageWithContentsOfFile:[ NSString getDocumentPathWithSuffixCompoment:mm.messageBody ]];
        }
    } else if(mm.cmode == chatModeVideo){  // 语音
        label.text = nil;
        pic.frame = CGRectMake(40, 8, 30, 30);
        pic.image = [UIImage imageNamed:@"chat_bottom_voice_press"];
    } else {                 // 文字
    
    }
    
    
    // 结束问诊
    if (mm.ccategory == chatCatagoryPrediagnosisReport) {
//        NSDictionary *reDic = mm.reportDic;
        NSString *problemS = mm.problem;
        NSString *suggestS = mm.suggest;
//        NSLog(@"reprotDic:%@ -- problem:%@ -- suggest:%@",mm.reportDic,mm.problem,mm.suggest);
        for (id obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
//        [chatBackGroundImgV removeFromSuperview];
        
        
        EndPrediagnosisView *endV = [[EndPrediagnosisView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth , 283)];
        endV.problem = problemS;
        endV.tag = 1009;
        endV.suggest = suggestS;
        [endV setGetScore:^{
            [self showAlertViewWithMessage:@"查看评分"];
        }];
//        endV.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:endV];
    }
    return cell;
}
- (NSString *)getFifteenminutesLaterTimeString {
    NSDate *date=  [NSDate date];
    NSTimeInterval interval = 15*60;
    
    NSDate *theDate;
    theDate = [date initWithTimeIntervalSinceNow:interval];
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *str = [fm stringFromDate:theDate];
    return str;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    NSDictionary *dict = _currentMessageArr[indexPath.row];
    MessageModel *mm = [dict allValues][0];
    if (mm.cmode == chatModeVideo) {
        NSData *data;
        NSString *audioPath;
        if ([mm.toOrFrom isEqualToString:kMessageFormUser]) {
            NSString *s = mm.messageBody;
            NSString *suffix = [[s componentsSeparatedByString:[NSString stringWithFormat:@"%@",@"/"]] lastObject];
            audioPath = suffix;
            NSString *existPath = [NSString getDocumentPathWithSuffixCompoment:audioPath];
            if ([[NSFileManager defaultManager] fileExistsAtPath:existPath]) {
                
            } else {
                NSURL *url = [NSURL URLWithString:[@"http://115.159.49.31:9000" stringByAppendingString:mm.messageBody]];
                data = [NSData dataWithContentsOfURL:url];
                [data writeToFile:existPath atomically:YES];
            }
        } else {
            audioPath = mm.messageBody ;
        }
        [self playAudioWithPathSuffix:audioPath];
    }
}

// 问诊页上传图片点击  显示大图?
- (void)inquiryImageTap:(UIGestureRecognizer *)ges {
    NSInteger index = ges.view.tag - 120;
    _bigImgVBack = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _bigImgVBack.backgroundColor = [UIColor lightGrayColor];
    _bigImgVBack.userInteractionEnabled = YES;
    [_bigImgVBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImgV)]];
    [self.view addSubview:_bigImgVBack];
    
    UIImage *img = _picArr[index];
    CGSize size = img.size;
    CGSize s;
    if (size.width > kScreenWidth) {
        s.width = kScreenWidth;
    } else s.width = size.width;
    
    s.height =size.height / size.width * s.width;
    UIImageView *IV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, s.width, s.height)];
    IV.center = _bigImgVBack.center;
    IV.image = img;

    [_bigImgVBack addSubview:IV];
}
- (void)removeImgV {
    [_bigImgVBack removeFromSuperview];
}
#pragma mark -
#pragma mark 点击播放录音

- (void)playAudioWithPathSuffix:(NSString *)path {
    NSString *audiopath = [NSString getDocumentPathWithSuffixCompoment:path];
    _playWavPath    = [VoiceRecorderBaseVC getPathByFileName:[NSString stringWithFormat:@"%@_play",[NSString getCurrentTimeString]] ofType:@"wav"];
    [VoiceConverter amrToWav:audiopath wavSavePath:_playWavPath];
    NSData *wavData = [NSData dataWithContentsOfFile:_playWavPath];
    if (!_player) {
        _player  = [[AVAudioPlayer alloc] init];
    }
    _player = [_player initWithData:wavData error:nil];
    _player.volume = 8;
    [_player prepareToPlay];
    [_player play];
    [[NSFileManager defaultManager] removeItemAtPath:_playWavPath error:nil];
}
@end
