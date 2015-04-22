//
//  VisitViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/11.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "VisitViewController.h"
#import "AddNewPatientViewController.h"
#import "AddPatientViewController.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "PatitentTableViewCell.h"



//---------------------------he-----------------------------------
 #import "DBManager.h"
 #import "ChatViewController.h"
 #import "UserModel.h"
 #import "MessageModel.h"
#import "FriendsModel.h"
#import "FRDListDBManger.h"
//-------------------------------------he-----------------------------

@interface VisitViewController ()
{
    UIButton *visitBtn1; //消息按钮
    UIButton *visitBtn2; //患者按钮
    
    UITableView *patientTableView; //患者tableview
    UITableView *informationTableView; //消息tableview
    
    //患者的数据
    NSArray *patientLableArray;
    NSMutableArray *patientlable2Array;
    NSMutableDictionary *patientBendiDic;
    NSMutableArray *parr;
    
    // ---------------------------he------------------
    NSMutableArray *_numberOfChatArr;  // 聊天个数  每一条是一个messagemodel
    UserModel      *_toUser;
    NSMutableArray *_patients;
    //---------------------------he---------
}

@property(strong,nonatomic)AFHTTPRequestOperationManager *manager;
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation VisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self headViewIcon];
    [self dataprocessing];
    
    //-----------------------------he-------------------------
    [self prepareData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify) name:kReceiveMessageNotification object:nil];
    //------------------------------he----------------------------
}


//  ---------------------------he---------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareData {
    if (!_numberOfChatArr) _numberOfChatArr = [NSMutableArray array];
    
    if (!_toUser)
        _toUser  = [[UserModel alloc] init];
    if (!_patients) {
        _patients = [NSMutableArray array];
    }
    [self quiryDataFromDB];
}

- (void)receiveNotify {
    
    [self quiryDataFromDB];
    [informationTableView reloadData];
}
// 从数据库取数据
- (void)quiryDataFromDB {
    NSMutableArray *arr = [[DBManager sharedManager] fetchAll];
    NSArray *reverceArr = [[arr reverseObjectEnumerator] allObjects];
    NSLog(@"最后条信息内容%@",[[reverceArr firstObject] message]);
    [_numberOfChatArr removeAllObjects];
    for (MessageModel *model in reverceArr) {
        if (_numberOfChatArr.count == 0) {
            [_numberOfChatArr addObject:model];
        } else {
            for (int i = 0; i<_numberOfChatArr.count; i++) {
                MessageModel *m = _numberOfChatArr[i];
                if ([model.messageId isEqualToString:m.messageId] || !model.messageId || !m.messageId) break;
                else if (i == _numberOfChatArr.count - 1) [_numberOfChatArr addObject:model];
            }
        }
    }
    
    _patients = [[FRDListDBManger sharedManager] fetchAll];
    
   if (!parr) parr = [NSMutableArray array];
    for (FriendsModel *fm in _patients) {
        
        [ patientBendiDic setObject:fm.name == nil? @"无名" : fm.name forKey:@"name"];
        [parr addObject:patientBendiDic];
        
        
//        [parr addObject:fm.name == nil? @"无名" : fm.name];
    }
    [patientlable2Array addObjectsFromArray: parr];
}
//--------------------------he---------------------------


#pragma mark 杂乱数据
-(void)dataprocessing{
    informationTableView.dataSource=self;
    informationTableView.delegate=self;
    patientTableView.dataSource=self;
    patientTableView.delegate=self;
    
    //患者的数据
    patientLableArray=@[@"新增患者",@"标签",@"医疗助理",@""];
    patientlable2Array=[NSMutableArray array];
    patientBendiDic=[NSMutableDictionary dictionary];
    
    
    
    
    self.manager=[AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer=[AFJSONResponseSerializer serializer];
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
}

#pragma mark headView
-(void)headViewIcon{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
#pragma mark 添加消息 患者 tableview
    informationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+80, kScreenWidth, kScreenHeight-kNavigationBarHeight-60-self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
    informationTableView.backgroundColor=[UIColor clearColor];
    informationTableView.bounces=NO;
    informationTableView.showsVerticalScrollIndicator=NO;
    informationTableView.tag=0;
    informationTableView.hidden=YES;
    informationTableView.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    informationTableView.tableHeaderView.alpha=0.1;
    informationTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:informationTableView];
    
    patientTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+60, kScreenWidth, kScreenHeight-kNavigationBarHeight-60-self.tabBarController.tabBar.bounds.size.height) style:UITableViewStylePlain];
    patientTableView.backgroundColor=[UIColor clearColor];
    patientTableView.bounces=NO;
    patientTableView.showsVerticalScrollIndicator=NO;
    patientTableView.tag=1;
    patientTableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:patientTableView];
    
#pragma mark    消息与患者按钮
    UIImageView *btnimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+20, kScreenWidth, 40)];
    btnimageview.backgroundColor=[UIColor whiteColor];
    btnimageview.alpha=0.1;
    [self.view addSubview:btnimageview];
    
    visitBtn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    visitBtn1.frame=CGRectMake(0, kNavigationBarHeight+20, kScreenWidth/2, 40);
    [visitBtn1 setTitle:@"消息" forState:UIControlStateNormal];
    [visitBtn1 addTarget:self action:@selector(visitAdd:) forControlEvents:UIControlEventTouchUpInside];
    visitBtn1.tag =  0;
    visitBtn1.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [visitBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    visitBtn1.backgroundColor=[UIColor clearColor];
//    [visitBtn1 setBackgroundImage:[UIImage imageNamed:@"actinBackyanse.png"] forState:UIControlStateNormal];
    [self.view addSubview:visitBtn1];
    
    visitBtn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    visitBtn2.frame=CGRectMake(kScreenWidth/2, kNavigationBarHeight+20, kScreenWidth/2, 40);
    [visitBtn2 setTitle:@"患者" forState:UIControlStateNormal];
    [visitBtn2 addTarget:self action:@selector(visitAdd:) forControlEvents:UIControlEventTouchUpInside];
    visitBtn2.tag =  1;
    visitBtn2.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [visitBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    visitBtn2.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
//    [visitBtn2 setBackgroundImage:[UIImage imageNamed:@"actionImage.png"] forState:UIControlStateNormal];
    [self.view addSubview:visitBtn2];
}

#pragma mark 按钮事件
-(void)visitAdd:(UIButton *)sender{
    if(sender.tag==0){
//        sender.frame=CGRectMake(0, kNavigationBarHeight+20, kScreenWidth/2, 48);
//        [sender setBackgroundImage:[UIImage imageNamed:@"actionImage.png"] forState:UIControlStateNormal];
//        visitBtn2.frame=CGRectMake(kScreenWidth/2, kNavigationBarHeight+20, kScreenWidth/2, 40);
//        [visitBtn2 setBackgroundImage:[UIImage imageNamed:@"actinBackyanse.png"] forState:UIControlStateNormal];
        visitBtn1.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
        visitBtn2.backgroundColor=[UIColor clearColor];
        informationTableView.hidden=NO;
        patientTableView.hidden=YES;
        [informationTableView reloadData];
        
    }else if(sender.tag==1){
//        sender.frame=CGRectMake(kScreenWidth/2, kNavigationBarHeight+20, kScreenWidth/2, 48);
//        [sender setBackgroundImage:[UIImage imageNamed:@"actionImage.png"] forState:UIControlStateNormal];
//        visitBtn1.frame=CGRectMake(0, kNavigationBarHeight+20, kScreenWidth/2, 40);
//        [visitBtn1 setBackgroundImage:[UIImage imageNamed:@"actinBackyanse.png"] forState:UIControlStateNormal];
        visitBtn1.backgroundColor=[UIColor clearColor];
        visitBtn2.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
        informationTableView.hidden=YES;
        patientTableView.hidden=NO;
    }
}

#pragma mark - Table view data source
#pragma mark 块
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag==0){
       return 1;
    }else
        return 2;
}

#pragma mark 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag==0){
        return _numberOfChatArr.count;
        
    }else if(tableView.tag==1){
       if(section==0){
            return patientLableArray.count;
        }else
            return patientlable2Array.count;
    }
    return 0;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *visitIdentifier=@"visit";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:visitIdentifier];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:visitIdentifier];
    }
    
    if(tableView.tag==0){
        
        InformationTableViewCell *informationCell=[InformationTableViewCell InformationTableViewCell1];
        informationCell.backgroundColor=[UIColor clearColor];
        informationCell.askHeadImage.layer.cornerRadius=20;
        informationCell.askHeadImage.layer.masksToBounds=YES;
//-----------------------------he-----------------------
        if(_numberOfChatArr.count!=0){
            MessageModel *model = _numberOfChatArr[indexPath.row];
            informationCell.askNameLable.text=model.messageId;
            if (model.ccategory == chatCatagoryNormal) {
                if (model.cmode == chatModeString) {
                    informationCell.askContent.text = model.messageBody;
                } else if (model.cmode == chatModeVideo) {
                    informationCell.askContent.text = @"[语音]";
                } else if (model.cmode == chatModePicture) {
                    informationCell.askContent.text = @"[图片]";
                }
            } else if (model.ccategory == chatCatagoryPrediagnosisReport) {
                informationCell.askContent.text = @"[问诊报告]";
                
            }  else if (model.ccategory == chatCatagoryFindDr) {
                
                informationCell.askContent.text = model.messageBody;
            }
        }
//--------------------------he---------------------------
        return informationCell;
        
    }else if(tableView.tag==1){
        
        if(indexPath.section==0){
            NSArray *headImageArray=@[@"07_03",@"07_07",@"07_11",@""];
            cell.imageView.image=[UIImage imageNamed:headImageArray[indexPath.row]];
            cell.backgroundColor=[UIColor clearColor];
            cell.textLabel.text=patientLableArray[indexPath.row];
            cell.textLabel.textColor=[UIColor whiteColor];
            return cell;
            
        }else if(indexPath.section == 1){
            PatitentTableViewCell *patientcell = [PatitentTableViewCell patitentTableViewCell];
            patientcell.textLabel.text=[patientlable2Array[indexPath.row] objectForKey:@"name"];
            patientcell.textLabel.textColor=[UIColor whiteColor];
            return patientcell;
            
        }else{
           cell.backgroundColor=[UIColor clearColor];
           return cell;
        }
    }
    
    return cell;
}

#pragma mark section height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView.tag==0){
        return 1;
    }else if(tableView.tag==1){
        if(section==1){
            return 30;
        }else
            return 0;
    }else
        return 0;
}

#pragma mark row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==0){
        return 80;
    }else if(tableView.tag==1){
        if (indexPath.section==0 && indexPath.row == 3) {
            return 18;
        }else
            return 44;
    }else
        return 0;
}

#pragma mark section View
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(tableView.tag==1){
        UIView *patientSectionView=[[UIView alloc]init];
        patientSectionView.backgroundColor=[UIColor clearColor];
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        imageview.backgroundColor=[UIColor whiteColor];
        imageview.alpha=0.4;
        [patientSectionView addSubview:imageview];
        
        UILabel *patientSectionViewLable=[[UILabel alloc]initWithFrame:CGRectMake(40, 5, kScreenWidth, 20)];
        patientSectionViewLable.textColor=[UIColor whiteColor];
        patientSectionViewLable.text=@"重点关注";
        [patientSectionView addSubview:patientSectionViewLable];
        return patientSectionView;
        
    }else
        return nil;
}

#pragma mark 视图将要出现时
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden=YES;
    self.tabBarController.tabBar.hidden=NO;
    self.doctor=[UserInfo sharedUserInfo];
    
    
    
    informationTableView.hidden=NO;
    patientTableView.hidden=YES;
    visitBtn1.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
    visitBtn2.backgroundColor=[UIColor clearColor];
    
    [informationTableView reloadData];
    
    [self quiryDataFromDB];
    [self neteorking];
}


#pragma mark   select row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//----------------------------------------he---------------------------------
    if (tableView == informationTableView) {
        
        ChatViewController *vc = [[ChatViewController alloc] init];
//        self.navigationController.navigationBar.hidden=NO;
        vc.inquiryID = [_numberOfChatArr[indexPath.row] inquiryID];
        vc.patientID = [_numberOfChatArr[indexPath.row] patientID];
        
        [self.navigationController pushViewController:vc animated:YES];
 //---------------------------------------------he---------------------------------------
        
    }else if(tableView.tag == 1){
        if(indexPath.section == 0 && indexPath.row == 0){
            
            AddPatientViewController *addPatientView=[[AddPatientViewController alloc]init];
            [self.navigationController pushViewController:addPatientView animated:YES];
            
        }
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 获取数据
-(void)neteorking{
    
    NSString *paitintCaseUrl=[NSString stringWithFormat:@"http://115.159.49.31:9000/doctor/friends/get?uid=%@&sessionkey=%@&page=0&limit=10",self.doctor.userID,self.doctor.sessionKey];
    
    [self.manager GET:paitintCaseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=(NSDictionary *)responseObject;
        if([[dict objectForKey:@"code"]integerValue ]==0){
            [patientlable2Array removeAllObjects];
            
            if([[dict objectForKey:@"friends"]count]!=0){
                
                
              //  [self quiryDataFromDB];
                
                
                for(NSInteger i=0; i< parr.count; i++){
                    [patientlable2Array addObject:parr[i]];
                }
                
                for(NSInteger i=0; i<[[dict objectForKey:@"friends"]count];i++){
                    [ patientlable2Array addObject:[dict objectForKey:@"friends"][i]];
                }

            }
   
            [patientTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
