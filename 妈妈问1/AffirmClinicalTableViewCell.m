//
//  AffirmClinicalTableViewCell.m
//  妈妈问1
//
//  Created by netshow on 15/2/28.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import "AffirmClinicalTableViewCell.h"

@implementation AffirmClinicalTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+(AffirmClinicalTableViewCell *)AffirmClinicalTableViewCell
{
    return [[NSBundle mainBundle]loadNibNamed:@"AffirmClinicalTableViewCell" owner:nil options:nil][0];
}

#pragma mark  -附件
-(void)addOther
{
    self.affirmNameLable.text=self.askName3;
    self.affirmLable2.text=self.askSubhead3;
    
    self.askHeadImage.layer.cornerRadius=20;
    self.askHeadImage.layer.masksToBounds=YES;

    //详细描述
    self.affirmLable4=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, kScreenWidth-40, 40)];
    self.affirmLable4.text=self.askString3;
    self.affirmLable4.textColor=[UIColor whiteColor];
    self.affirmLable4.font=[UIFont systemFontOfSize:17.0f];
    [self addSubview:self.affirmLable4];
    
    //  根据字体改变长度
    self.affirmLable4.numberOfLines=0;
    CGSize size1 = CGSizeMake(kScreenWidth-40, 0);
    CGSize lablesize1 = [self.affirmLable4 sizeThatFits:size1];
    self.affirmLable4.frame = CGRectMake(20, 60, lablesize1.width, lablesize1.height);
    
    UIImageView *pictureimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.affirmLable4.frame)+13, 20, 15)];
    pictureimageview.image=[UIImage imageNamed:@"picture.png"];
    [self addSubview:pictureimageview];
    
    UILabel *pictureLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(pictureimageview.frame)+10, CGRectGetMaxY(self.affirmLable4.frame)+10, 80, 20)];
    pictureLable.text=@"图片附件";
    pictureLable.textColor=[UIColor whiteColor];
    pictureLable.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:pictureLable];
    
    //图片附件
    UIImageView *imageview;
    UIImageView *minimageview=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"drug.png"]];
    UILabel *minLable=[[UILabel alloc]init];
    for(int i=0;i<[self.askPictureNumber3 integerValue];i++){
        imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20+(i%4)*((kScreenWidth-40)/4), CGRectGetMaxY(pictureLable.frame)+10 +(i/4)*60, (kScreenWidth-40)/5, 50)];
      
        imageview.backgroundColor=[UIColor redColor];
        [self addSubview:imageview];
        // NSLog(@"minimageview--%f",CGRectGetMaxY(imageview.frame));
    }
    if([self.askPictureNumber3 isEqualToString:@"0"] || [self.askPictureNumber3 isEqualToString:@""] ||self.askPictureNumber3==nil){
       minimageview.frame=CGRectMake(20, CGRectGetMaxY(pictureLable.frame)+20, 20, 15);
        minLable.frame=CGRectMake(45, CGRectGetMaxY(pictureLable.frame)+20, 60, 20);
    }else{
       minimageview.frame=CGRectMake(20, CGRectGetMaxY(imageview.frame)+5, 20, 20);
       minLable.frame=CGRectMake(45, CGRectGetMaxY(imageview.frame)+5, 60, 15);
    }
    [self addSubview:minimageview];
    
  
  
    minLable.text=@"正在用药";
    minLable.textColor=[UIColor whiteColor];
    minLable.font=[UIFont systemFontOfSize:12.0f];
    [self addSubview:minLable];
   // NSLog(@"minlable---%f",CGRectGetMaxY(minLable.frame));
    
    //正在用药Lable
    UILabel *drugLable;
    for(int j=0;j<1;j++){
        drugLable=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(minLable.frame)+10, 60, 20)];
        drugLable.text=@"百咳静糖浆";
        drugLable.font=[UIFont systemFontOfSize:12.0f];
        [self addSubview:drugLable];
    }
    
    UILabel *jiahao=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-60, CGRectGetMaxY(drugLable.frame)+30, 20, 40)];
    jiahao.text=@"+";
    jiahao.textColor=[UIColor whiteColor];
    jiahao.textAlignment=NSTextAlignmentRight;
    jiahao.font=[UIFont systemFontOfSize:20.0f];
    [self addSubview:jiahao];
    
    UILabel *jifen=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jiahao.frame), CGRectGetMaxY(drugLable.frame)+30, 40, 40)];
    jifen.text=self.askIntegral3;
    jifen.textColor=[UIColor whiteColor];
    jifen.textAlignment=NSTextAlignmentCenter;
    jifen.font=[UIFont systemFontOfSize:35.0f];
    [self addSubview:jifen];
    
    UILabel *jinbi=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(jifen.frame), CGRectGetMaxY(drugLable.frame)+30, 40, 40)];
    jinbi.text=@"金币";
    jinbi.textColor=[UIColor whiteColor];
    jinbi.textAlignment=NSTextAlignmentLeft;
    jinbi.font=[UIFont systemFontOfSize:20.0f];
    [self addSubview:jinbi];
    
    UIView *lineview=[[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(drugLable.frame)+10, kScreenWidth-40, 0.5)];
    lineview.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineview];
    
//    //剩余接诊时间
//    UILabel *lastLable=[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(lineview.frame)+15, 80, 20)];
//    lastLable.font=[UIFont systemFontOfSize:12.0];
//    lastLable.textColor=[UIColor lightGrayColor];
//    lastLable.text=@"剩余接诊时间";
//    [self addSubview:lastLable];
//    
//     _a=60;
//    
//    
//    for(NSInteger i=0;i<8;i++){
//        _shijian=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLable.frame)+10+i*17, CGRectGetMaxY(lineview.frame)+15, 15, 20)];
//        _shijian.tag=i+1;
//        _shijian.font=[UIFont systemFontOfSize:15.0f];
//
//        if(i==2 || i==5){
//            _shijian.text=@":";
//            _shijian.backgroundColor=[UIColor whiteColor];
//            _shijian.textColor=[UIColor lightGrayColor];
//        }else{
//            if(i==0 || i==1 || i==3){
//                _shijian.text=@"0";
//            }else if(i==4){
//                _shijian.text=[NSString stringWithFormat:@"%i",(_a/60)];
//            }else if(i==6){
//                _shijian.text=[NSString stringWithFormat:@"%i",(_a%60)/10];
//            }else if(i==7){
//                _shijian.text=[NSString stringWithFormat:@"%i",(_a%60)%10];
//            }
//           
//           _shijian.backgroundColor=[UIColor lightGrayColor];
//            _shijian.textColor=[UIColor whiteColor];
//        }
//        _shijian.textAlignment=NSTextAlignmentCenter;
//        [self addSubview:_shijian];
//        
//       
//    }
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(autoScroll:) userInfo:nil repeats:NO];
    
    NSInteger cellheight=CGRectGetMaxY(jinbi.frame)+20;
    if(cellheight>=(kScreenHeight-20-44-50)){
        cellheight=cellheight;
    }else
        cellheight=kScreenHeight-114;
    [self.delegate changeCellHeight:cellheight];
}

//#pragma mark 定时更新时间方法
//-(void)autoScroll:(NSTimer *)timer{
//    UILabel *lable5=(UILabel *)[self viewWithTag:5];
//    UILabel *lable7=(UILabel *)[self viewWithTag:7];
//    UILabel *lable8=(UILabel *)[self viewWithTag:8];
//    _a--;
// 
//    lable5.text=[NSString stringWithFormat:@"%i",_a/60];
//    lable7.text=[NSString stringWithFormat:@"%i",(_a%60)/10];
//    lable8.text=[NSString stringWithFormat:@"%i",(_a%60)%10];
//    NSTimer *time2=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(autoScroll:) userInfo:nil repeats:NO];
//    if(_a==0){
//      [time2 invalidate];
//    }
//}

@end
