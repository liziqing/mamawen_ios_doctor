//
//  CinicalViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/12.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "CinicalViewController.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "AddPatientViewController.h"
#import "DateRemendVC.h"


@interface CinicalViewController () <MJRefreshBaseViewDelegate>
{
    UIView *midview;//滑动的小view
    NSInteger currentAction;//选定的按钮
    NSMutableArray *myarray1; //按钮数组
    UIView *slideView;    //section = 1 时headerview上的子view
    NSInteger buttomNumber; //确定滑动的midview的位置标识

    NSMutableArray *dataNameArray1;  //提问的用户名数组
    NSMutableArray *dataIDArray;
    NSMutableArray *DataJidArray;
    NSMutableArray *dataSubheadArray1; //提问者的副标题
    NSMutableArray *dataIntegral; //获取的金币
    NSMutableArray *dataAskArray1;   //提问者的问题
    NSMutableArray *dataAskPictureNumber; //提问者上传的图片数量
    NSMutableArray *askIDArray;//第几个问题

    UIBarButtonItem *backbtn; //跳转页的按钮
    
    UIScrollView *myscrollview;//LOGO Scrollview
    UIPageControl *pagecontrolView;
    
    //日程提醒数量
    NSString *dateRemindNumber;
    NSString *dateRemindNumberStoragePath;
    NSMutableArray *dateRemindNumberArray;//存储
    NSArray *dateRemindNumberExtractArray;//提取
    
    /////////////////////////////---下拉刷新
    MJRefreshHeaderView *headerRefesh;
    MJRefreshFooterView *footerRefesh;
    
    NSUInteger page;
    BOOL refeshing;
    ////////////////
    
    NSArray *dictionName; //用户问题数据数组
    
//-------网络请求----日程字典
    AFHTTPRequestOperationManager *manager;
    NSDictionary *remindDateRemendVcDict;
    
}
@property(strong,nonatomic)UITableView *zhuTableView;
@property(strong,nonatomic)UserInfo *doctor;

@end

@implementation CinicalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self dataprocessing];
    [self changeNavigationBar];
}

#pragma mark 数据处理
-(void)dataprocessing
{
//背景视图
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    dataNameArray1=[NSMutableArray array];
    dataIDArray=[NSMutableArray array];
    DataJidArray=[NSMutableArray array];
    dataSubheadArray1=[NSMutableArray array];
    dataIntegral=[NSMutableArray array];
    dataAskArray1=[NSMutableArray array];
    dataAskPictureNumber=[NSMutableArray array];
    askIDArray=[NSMutableArray array];
    
//--------------------------网络请求
    manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    //医生问诊列表 tableview
    self.zhuTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-kNavigationBarHeight-20-kTabBarHeight)];
    self.zhuTableView.dataSource=self;
    self.zhuTableView.delegate=self;
    self.zhuTableView.backgroundColor=[UIColor clearColor];
    self.zhuTableView.bounces=YES;
    self.zhuTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.zhuTableView];
    
    
//#pragma mark    //获取网络数据
//    [self dataNum:@selector(loadData:) failer:@selector(loadDatafailer:) targe:self];
    
#pragma mark   //////////////////--下拉刷新
    
    headerRefesh = [[MJRefreshHeaderView alloc] initWithScrollView:self.zhuTableView];
    footerRefesh = [[MJRefreshFooterView alloc] initWithScrollView:self.zhuTableView];
    
    headerRefesh.delegate = self;
    footerRefesh.delegate = self;
    
    
#pragma mark  tabBar
    self.tabBarController.tabBar.tintColor=[UIColor colorWithRed:0.18 green:0.83 blue:0.91 alpha:1];
    self.zhuTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.zhuTableView.tableFooterView=[[UIView alloc]init];
    currentAction=0;
    myarray1=[NSMutableArray array];
    
    backbtn=[[UIBarButtonItem alloc]init];
    self.navigationItem.backBarButtonItem=backbtn;
    backbtn.title=@"返回";
    self.navigationController.navigationBar.tintColor=[UIColor lightGrayColor];
    

    buttomNumber=0;  //滑动view的标识
    
    //日程提醒个数的存储地址及数量
    dateRemindNumberArray=[NSMutableArray array];
    dateRemindNumberStoragePath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    dateRemindNumberStoragePath = [dateRemindNumberStoragePath stringByAppendingPathComponent:@"dateRemindNunmber.plist"];
    dateRemindNumberExtractArray=[[NSArray alloc]initWithContentsOfFile:dateRemindNumberStoragePath];
    if(dateRemindNumberExtractArray.count==0){
        dateRemindNumber=@"0";
    }else{
        dateRemindNumber=dateRemindNumberExtractArray[0];
    }
    
#pragma mark    //广告ScrollView
    myscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    for(int i=0;i<3;i++){
        NSString *imageFile = [NSString stringWithFormat:@"接诊_0%i.png",1];
        UIImage *image = [UIImage imageNamed:imageFile];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        NSInteger x = i* kScreenWidth;
        [imageView setFrame:CGRectMake(x, 0, kScreenWidth, myscrollview.bounds.size.height)];
        [myscrollview addSubview:imageView];
    }
    myscrollview.bounces=NO;
    myscrollview.showsHorizontalScrollIndicator=NO;
    myscrollview.contentSize=CGSizeMake(3*kScreenWidth, myscrollview.bounds.size.height);
    [myscrollview setPagingEnabled:YES];
    [myscrollview setDelegate:self];
    pagecontrolView=[[UIPageControl alloc]initWithFrame:CGRectMake(kScreenWidth-130, 40, 100, 20)];
    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [self addPages];
}

#pragma mark   ///////////////////////  下拉刷新
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        page = 0;
        
        [self dataNum:@selector(loadData:) failer:@selector(loadDatafailer:) targe:self];
        refeshing = YES;
    } else {
        
        page += 1;
        
        [self dataNum:@selector(loadData:) failer:@selector(loadDatafailer:) targe:self];
        refeshing = NO;
    }
}

#pragma mark   ///////////// 结束下拉刷新
- (void)endRefresh {
    
    if (headerRefesh) {
        [headerRefesh endRefreshing];
    }
    
    if (footerRefesh) {
        [footerRefesh endRefreshing];
    }
}

#pragma mark changeNavigationBar
-(void)changeNavigationBar{
    
    //标题
    UILabel *headTitle=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-55, 27, 120, 30)];
    headTitle.center=CGPointMake(kScreenWidth/2-5, 45);
    headTitle.text=@"正在接诊";
    headTitle.textAlignment=NSTextAlignmentCenter;
    headTitle.textColor=[UIColor whiteColor];
    headTitle.font=[UIFont systemFontOfSize:20.0f];
    [self.view addSubview:headTitle];
    
    UIImageView *headImageview=[[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2+36, 38, 15, 10)];
    headImageview.image=[UIImage imageNamed:@"xiaIcon"];
    [self.view addSubview:headImageview];
    
//--------------------------------添加患者按钮
    UIButton *registerIcon=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerIcon.frame=CGRectMake(kScreenWidth-60, 20, 60, 40);
    registerIcon.tag=0;
    [registerIcon addTarget:self action:@selector(actionIcon:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerIcon];
    
}

#pragma mark 添加患者事件
-(void)actionIcon:(UIButton *)sender{
    if(sender.tag==0){
        AddPatientViewController *addPatientView=[[AddPatientViewController alloc]init];
        [self.navigationController pushViewController:addPatientView animated:YES];
    }
    
}


#pragma mark - Table view data source
#pragma mark section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0 ){
        return 2;
    }else{

         return dataNameArray1.count;
    }
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myidentifier=@"clinica";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myidentifier];
    if ( cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myidentifier];
    }
    if(indexPath.section==0 && indexPath.row==0){
        [cell.contentView addSubview:myscrollview];
        [cell.contentView addSubview:pagecontrolView];
        
    }else if(indexPath.section==0 && indexPath.row==1){
        
        MyTableViewCell2 *cell2=[MyTableViewCell2 Mytableviewcell2];
        cell2.mylable1.text=@"今日日程";
        cell2.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel *cell2Lable2=[[UILabel alloc]initWithFrame:CGRectMake(70, 30, 40, 20)];
        
        if(remindDateRemendVcDict != nil){
           cell2Lable2.text=[NSString stringWithFormat:@"%@ %@",[remindDateRemendVcDict objectForKey:@"remindTime"],[remindDateRemendVcDict objectForKey:@"patientName"]];
        }else{
            cell2Lable2.text=@"暂无日程提醒";
        }
        cell2Lable2.textColor=[UIColor whiteColor];
        cell2Lable2.font=[UIFont systemFontOfSize:12.0f];
        //  根据字体改变长度
        cell2Lable2.numberOfLines=1;
        CGSize size1 = CGSizeMake(kScreenWidth-120, 20);
        CGSize lablesize1 = [cell2Lable2 sizeThatFits:size1];
        cell2Lable2.frame = CGRectMake(70, 30, lablesize1.width, 20);
        [cell2.contentView addSubview:cell2Lable2];
        
        UIImageView *cell2imageview=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cell2Lable2.frame)+5, 35, 10, 10)];
        cell2imageview.image=[UIImage imageNamed:@"jiezhengnaoling"];
        [cell2.contentView addSubview:cell2imageview];
 
        
        
        cell2.backgroundColor=[UIColor clearColor];
        return cell2;


    }else if(indexPath.section== 1){
        MyTableViewCell3 *cell3=[MyTableViewCell3 Mytableviewcell3];
        if(dataNameArray1.count!=0){
            cell3.userHeadImage.layer.cornerRadius=20;
            cell3.userHeadImage.layer.masksToBounds=YES;
            
            cell3.userHeadImage.image=[UIImage imageNamed:@"医生版0311_10"];
           cell3.cell3mylable1.text=dataNameArray1[indexPath.row];
           cell3.cell3mylable2.text=dataSubheadArray1[indexPath.row];
           //cell3.cell3mylable3.text=dataIntegral[indexPath.row];
            cell3.cell3mylable4.text=dataAskArray1[indexPath.row];
        }
            cell3.selectionStyle=UITableViewCellSelectionStyleNone;
            cell3.backgroundColor=[UIColor clearColor];
            return cell3;
    }
        return cell;
}

#pragma mark   scrollview中的imageview定时移动方法
- (void)autoScroll{
    CGPoint point;
    if (myscrollview.contentOffset.x < 2*myscrollview.bounds.size.width) {
        point = CGPointMake(myscrollview.contentOffset.x + kScreenWidth, 0);
        [myscrollview setContentOffset:point animated:YES];
    } else {
        point = CGPointZero;
        [myscrollview setContentOffset:CGPointZero animated:YES];
    }
    pagecontrolView.currentPage = point.x/kScreenWidth;
}

#pragma mark 分页控件
-(void)addPages{
    
    pagecontrolView.numberOfPages=3;
    pagecontrolView.currentPage=0;
    pagecontrolView.currentPageIndicatorTintColor = [UIColor yellowColor];
    pagecontrolView.pageIndicatorTintColor = [UIColor redColor];
    [pagecontrolView addTarget:self action:@selector(updateScrollPage) forControlEvents:UIControlEventValueChanged];
}

#pragma mark 分页控件方法
-(void)updateScrollPage{
    CGPoint offsetPoint = CGPointMake(pagecontrolView.currentPage*kScreenWidth, 0);
    [myscrollview setContentOffset:offsetPoint animated:YES];
}

#pragma mark 计算分页控件的当前页
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pagecontrolView.currentPage = scrollView.contentOffset.x/kScreenWidth;
}

#pragma mark section Height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0 ) {
        return 0;
        
    }else{
        
        return 10;
    }
}

#pragma mark   row Height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return 80;
        
    }else if(indexPath.section==0 && indexPath.row==1){
        return 60;
        
    }else
        return 120;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        slideView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        slideView.backgroundColor=[UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
        //[self addSlideViewAction];
        slideView.backgroundColor=[UIColor clearColor];
        return slideView;
    }else
        return [[UIView alloc]init];
}

#pragma mark 暂时不调用
#pragma mark  slideView上添加按钮-------
/*-(void)addSlideViewAction{
    midview=[[UIView alloc]init];
    if(buttomNumber==0){
        midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20, 10, 60, 30);
    }else if(buttomNumber==1){
        midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20+(kScreenWidth-20)/3, 10, 60, 30);
    }else if(buttomNumber==2){
        midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20+2*(kScreenWidth-20)/3, 10, 60, 30);
    }
    midview.backgroundColor=[UIColor colorWithRed:0.18 green:0.83 blue:0.91 alpha:1];
    midview.layer.cornerRadius=14;
    midview.layer.masksToBounds=YES;
    [slideView addSubview:midview];

    NSArray *myarray=@[@"儿科",@"妇科",@"产科"];
    for(int i=0;i<myarray.count;i++){
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(10+(kScreenWidth-20) / 3 * i , 10, (kScreenWidth-20)/3, 30 );
        [btn setTitle:myarray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonsClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag =  i;
        btn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTintColor:[UIColor clearColor]];

        [myarray1 addObject:btn];
        [slideView addSubview:btn];

        if (i == currentAction){
            btn.selected = YES;
        }
    }
}
-(void)buttonsClick:(UIButton *)sender{
    for (UIButton *btn in myarray1) {
        btn.selected = NO;
    }
    if (sender.tag==0) {
        dataNameArray1=@[@"3",@"2",@"1",@"as"];
        currentAction=sender.tag;
        buttomNumber=0;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        [UIView animateWithDuration:0.2f animations:^{
            midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20, 10, 60, 30);
        }];

    }else if(sender.tag==1){

        dataNameArray1=@[@"5",@"2",@"1",@"56"];
           currentAction=sender.tag;
        buttomNumber=1;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        [UIView animateWithDuration:0.2f animations:^{
            midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20+(kScreenWidth-20)/3, 10, 60, 30);
        }];
    }else if(sender.tag==2){
        dataNameArray1=@[@"3",@"6",@"1",@"sdf"];
        currentAction=sender.tag;
        buttomNumber=2;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

        [UIView animateWithDuration:0.2f animations:^{
            midview.frame=CGRectMake(((kScreenWidth-20)/3)/2-20+2*(kScreenWidth-20)/3, 10, 60, 30);
        }];
    }
    sender.selected=YES;
    currentAction=sender.tag;

}*/

#pragma mark 让tableview的section HeaderView跟随tableview消失于视图顶部
/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (scrollView == self.tableView){
    //        CGFloat sectionHeaderHeight = 50;
    //        if (scrollView.contentOffset.y<=sectionHeaderHeight && scrollView.contentOffset.y>=0) {
    //            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentOffset.y+50, 0, 0, 0);
    //        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
    //            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    //        }
    //    }
    
    if (scrollView == self.zhuTableView){
        if (scrollView.contentOffset.y<=16 && scrollView.contentOffset.y>0) {
            NSLog(@"-1-%f",scrollView.contentOffset.y);
            
            scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentOffset.y+64, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=16) {
            scrollView.contentInset = UIEdgeInsetsMake(-14, 0, 0, 0);
            NSLog(@"-2-%f",scrollView.contentOffset.y);
        }
    }
    
}*/

#pragma mark  select row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 && indexPath.row==1) {
        DateRemendVC *dateRemindView=[[DateRemendVC alloc]init];

        self.tabBarController.tabBar.hidden =YES;
        [self.navigationController pushViewController:dateRemindView animated:YES];
        
    }else if(indexPath.section==1 ){
        AffirmViewController *affirmclinical=[[AffirmViewController alloc]init];
        affirmclinical.hidesBottomBarWhenPushed=YES;
        if(dataAskArray1.count!=0){
            
//            affirmclinical.askDataDictionary=dictionName[indexPath.row];
//            affirmclinical.askName2=dataNameArray1[indexPath.row];
//            affirmclinical.askSubhead2=dataSubheadArray1[indexPath.row];
           // affirmclinical.askIntegral2=dataIntegral[indexPath.row];
 //           affirmclinical.askstring=dataAskArray1[indexPath.row];
//            affirmclinical.askPictureNumber2=dataAskPictureNumber[indexPath.row];
            affirmclinical.askID=askIDArray[indexPath.row];
            
            
//-------------------------------he----------------------------------------
            affirmclinical.patientjid=DataJidArray[indexPath.row];
//            NSLog(@"affirmclinical.patientjid---%@",affirmclinical.patientjid);
            
            affirmclinical.patientsessionkey=@"123";
            affirmclinical.patientuid=dataIDArray[indexPath.row];
            affirmclinical.patientinquiryID=askIDArray[indexPath.row];
//--------------------------------he-------------------------------------------
        
            [self.navigationController pushViewController:affirmclinical animated:YES];
        }
    }
}


#pragma mark 网络请求数据成功-接收数据
- (void)loadData:(NSData *)data {
    
    NSDictionary *myDatadiction=(NSDictionary *)data;
    dictionName=[myDatadiction objectForKey:@"inquiries"];
        
    if(dictionName.count!=0) {
        [dataNameArray1 removeAllObjects];
        [dataIDArray removeAllObjects];
        [DataJidArray removeAllObjects];
         [dataSubheadArray1 removeAllObjects];
         [dataIntegral removeAllObjects];
         [dataAskArray1 removeAllObjects];
         [dataAskPictureNumber removeAllObjects];
         [askIDArray removeAllObjects];
        
        for(NSInteger i=0;i<dictionName.count;i++){
            
            [dataNameArray1 addObject:[[dictionName[i] objectForKey:@"user"]objectForKey:@"userName"]];
            [dataIDArray addObject:[[dictionName[i] objectForKey:@"user"]objectForKey:@"userID"]];
            [DataJidArray addObject:[[dictionName[i] objectForKey:@"user"]objectForKey:@"jid"]];
            [dataSubheadArray1 addObject:[dictionName[i] objectForKey:@"department"]];
            [dataIntegral addObject:[dictionName[i] objectForKey:@"point"]];
            [dataAskArray1 addObject:[dictionName[i] objectForKey:@"content"]];
            [dataAskPictureNumber addObject:@""];
            
            [askIDArray addObject:[dictionName[i]objectForKey:@"id"]];  //问题ID
        }
    }
   [self endRefresh];
    
//   [self.zhuTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
   [self.zhuTableView reloadData];
}

#pragma mark 网络请求数据失败
-(void)loadDatafailer:(NSData *)failerData{
    [self endRefresh];
}


#pragma mark 视图将要出现时
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    self.navigationController.navigationBarHidden=YES;
    
    self.doctor=[UserInfo sharedUserInfo];
#pragma mark    //获取网络数据
    [self huoquricheng];

    [self dataNum:@selector(loadData:) failer:@selector(loadDatafailer:) targe:self];
//    [self.zhuTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)dealloc {
    if (headerRefesh) {
        [headerRefesh free];
    }
    if (footerRefesh) {
        [footerRefesh free];
    }
}

#pragma mark------ 医生登入后获取的数据
-(void)dataNum:(SEL)success failer:(SEL)failer targe:(id)targe {
    
    AFHTTPRequestOperationManager *manager1=[AFHTTPRequestOperationManager manager];
    manager1.responseSerializer=[AFJSONResponseSerializer serializer];
    manager1.requestSerializer=[AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"uid":self.doctor.userID, @"sessionkey" :self.doctor.sessionKey,@"limit":@"1000",@"page":@"0"};
    [manager1 GET:@"http://115.159.49.31:9000/inquiry/list?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"问题列表--%@",(NSDictionary *)responseObject);
        [targe performSelectorInBackground:success withObject:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [targe performSelectorInBackground:failer withObject:error];
    }];
}

#pragma mark-----获取日程列表
-(void)huoquricheng{
    NSDictionary *dict=@{@"uid":self.doctor.userID,@"sessionkey":@"3"};
    [manager GET:@"http://115.159.49.31:9000/doctor/reminder/get?" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict=(NSDictionary *)responseObject;
        
        if([[dict objectForKey:@"code"]intValue]==0 ){
            NSArray *myarray=[dict objectForKey:@"reminders"];
            if(myarray.count !=0){
                
                 NSDate *dayDate=[NSDate date];
                NSDateFormatter *dayFor=[[NSDateFormatter alloc]init];
                [dayFor setDateFormat:@"yyyy-MM-dd"];
              NSString *dayString1=[dayFor stringFromDate:dayDate];
                
                NSDictionary *dict1;
                for(NSInteger i=0;i<myarray.count;i++){
                    NSString *str4=[myarray[i]objectForKey:@"startDate"];
                    
                    if([dayString1 isEqualToString:str4]){
                          dict1=myarray[i];
                        break;
                    }
                }
            
                if(dict1 != nil){
                    
                    remindDateRemendVcDict=dict1;
                    
                }
                
                
            }else
                remindDateRemendVcDict=nil;
            [self.zhuTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败---%@",error);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
