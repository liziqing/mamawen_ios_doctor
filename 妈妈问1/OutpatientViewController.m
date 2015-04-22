//
//  OutpatientViewController.m
//  妈妈问1
//
//  Created by netshow on 15/3/20.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "OutpatientViewController.h"
#import "Constant.h"
#import "BackView.h"

@interface OutpatientViewController ()
{
    NSDictionary *infoDictionary;
    
    UIImageView *minimage;
}
@property(strong,nonatomic)UIImageView *InfoImage;  //空闲时间
@property(strong,nonatomic)NSMutableArray *infoImageArray;


@end

@implementation OutpatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataprocessing];
    [self timeBiaoge];
}

#pragma mark 杂乱数据
-(void)dataprocessing{
    BackView *backview=[[BackView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:backview];
     [self.view sendSubviewToBack:backview];
    
    self.quedingBtn.layer.cornerRadius=3;
    self.quedingBtn.layer.masksToBounds=YES;
    
    self.infoImageArray=[NSMutableArray array];
}

#pragma mark 时间表
-(void)timeBiaoge{
    NSArray *dayTimeArray=@[@"上午",@"下午",@"晚上"];
    NSArray *weekTimeArray=@[@"星一",@"星二",@"星三",@"星四",@"星五",@"星六",@"星日"];
    
    for(NSInteger i=0;i<3;i++){
        UILabel *mylable1=[[UILabel alloc]initWithFrame:CGRectMake(60+i*((kScreenWidth-90)/3), 70, (kScreenWidth-90)/3, 30)];
        mylable1.text=dayTimeArray[i];
        mylable1.font=[UIFont systemFontOfSize:13.0f];
        mylable1.textColor=[UIColor whiteColor];
        mylable1.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:mylable1];
    }
    for(NSInteger i=0;i<7;i++){
        UILabel *weekLable=[[UILabel alloc]initWithFrame:CGRectMake(30, 100+i*((kScreenHeight-220)/7), 30, (kScreenHeight-220)/7)];
        weekLable.text=weekTimeArray[i];
        weekLable.font=[UIFont systemFontOfSize:13.0f];
        weekLable.textAlignment=NSTextAlignmentCenter;
        weekLable.textColor=[UIColor whiteColor];
        [self.view addSubview:weekLable];
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(30, 99+(i+1)*((kScreenHeight-220)/7), kScreenWidth-60, 1)];
        line.backgroundColor=[UIColor whiteColor];
        line.alpha=0.4;
        [self.view addSubview:line];
        
    }
    for(NSInteger i=0;i<7;i++){
        for(NSInteger j=0;j<3;j++){
            _InfoImage=[[UIImageView alloc]initWithFrame:CGRectMake(60+j*((kScreenWidth-90)/3), 100+i*((kScreenHeight-220)/7), (kScreenWidth-90)/3, (kScreenHeight-220)/7)];
            _InfoImage.tag=[[NSString stringWithFormat:@"%li%li",(long)j,(long)i]integerValue];
            _InfoImage.userInteractionEnabled=YES;
            [self infoImageGR:_InfoImage];
            [self.view addSubview:_InfoImage];
            
            minimage=[[UIImageView alloc]initWithFrame:CGRectMake(_InfoImage.bounds.size.width/2-10,_InfoImage.bounds.size.height/2-10, 20, 20)];
            minimage.tag=[[NSString stringWithFormat:@"%li%li",(long)j,(long)i]integerValue];
            minimage.image=[UIImage imageNamed:@"03_03"];
            [_InfoImage addSubview:minimage];

            
            
            
        }
    }
}

#pragma mark infoImage的手势
-(void)infoImageGR:(UIImageView *)myImageView{
    UITapGestureRecognizer *imageRecognize=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoImageDianji:)];
    [myImageView addGestureRecognizer:imageRecognize];
}

#pragma mark 手势方法
-(void)infoImageDianji:(UITapGestureRecognizer *)parm{
    UIImageView *mimageview=(UIImageView *)[parm view];
    UIImageView *imageview=[mimageview subviews][0];
    
    
  //        "weekday": 1, //表示星期几， 0-6,0表示星期日，1就代表星期1
//        " timeSegment", 2 //表示一天划分的时间段，1表示上午，2表示下午，3表示晚上
    
    if(mimageview.tag==0){
        
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday":@(1),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
            
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
            
        }
        
    }else if(mimageview.tag==10){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(1),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }

    }else if(mimageview.tag==20){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(1),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==1){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(2),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==11){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(2),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==21){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(2),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==2){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(3),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==12){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(3),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==22){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(3),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==3){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(4),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==13){
        
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(4),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==23){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(4),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==4){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(5),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==14){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(5),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==24){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(5),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==5){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(6),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
            
        }
        
    }else if(mimageview.tag==15){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(6),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==25){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(6),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==6){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(0),@"timeSegment":@(1)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==16){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(0),@"timeSegment":@(2)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
        
    }else if(mimageview.tag==26){
        if([imageview.image isEqual:[UIImage imageNamed:@"03_03"]]){
            imageview.image=[UIImage imageNamed:@"03_05"];
            infoDictionary=@{@"weekday": @(0),@"timeSegment":@(3)};
            [self.infoImageArray addObject:infoDictionary];
        }else{
            imageview.image=[UIImage imageNamed:@"03_03"];
            [self.infoImageArray removeLastObject];
        }
    }
}

#pragma mark 返回 完成按钮
- (IBAction)backAndFinish:(UIButton *)sender {
    if(sender.tag==0){
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self.delegate transfer:self.infoImageArray];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
