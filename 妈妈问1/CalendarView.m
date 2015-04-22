
#import "CalendarView.h"
#import "Constant.h"

@interface CalendarView()

{
    
    NSCalendar *gregorian;
    NSInteger _selectedMonth;
    NSInteger _selectedYear;
    
//------------------今天的日期
    NSInteger _today;
    NSInteger _todayMonth;
    NSInteger _todayYear;
    UILabel *todayLable;
    UIImageView *remindInfoimageview;
    
    NSString *dateString;
    NSDateFormatter *format;
    
    NSDate *clickedDate;
    UIButton *button1;
    
}

@end

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//--------------------------------滑动的手势
        UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
        swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeleft];
        
        UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        todayLable=[[UILabel alloc]init];
        todayLable.layer.cornerRadius=(kScreenWidth-20)/14;
        todayLable.layer.masksToBounds=YES;
    
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self setCalendarParameters];
    _weekNames = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    
    components.day = 2;   //------1代表从周一开始   2代表从周日开始
    NSDate *firstDayOfMonth = [gregorian dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:firstDayOfMonth];
    int weekday = [comps weekday];
    weekday  = weekday - 2;
    
    if(weekday < 0)
        weekday += 7;
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.calendarDate];
    
    NSInteger columns = 7;
    NSInteger width = (kScreenWidth-20)/7;
    NSInteger originX = 20;
    NSInteger originY = 0;
    NSInteger monthLength = days.length;
    
#pragma mark----------------------月份标题

    format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy MMMM"];
    dateString = [[format stringFromDate:self.calendarDate] uppercaseString];


#pragma mark----------星期几
    for (int i =0; i<_weekNames.count; i++) {
        UIButton *weekNameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekNameLabel.titleLabel.text = [_weekNames objectAtIndex:i];
        [weekNameLabel setTitle:[_weekNames objectAtIndex:i] forState:UIControlStateNormal];
        
        [weekNameLabel setFrame:CGRectMake(originX+(width*(i%columns)), originY, width, width)];
        [weekNameLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weekNameLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        weekNameLabel.userInteractionEnabled = NO;
        [self addSubview:weekNameLabel];
    }
    
#pragma mark-----月份时间
    for (NSInteger i= 0; i<monthLength; i++)
    {
        button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.tag = i+1;
        button1.titleLabel.text = [NSString stringWithFormat:@"%d",i+1];
        [button1 setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        
#pragma mark-------------日期点击事件
        [button1 addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
        
        NSInteger offsetX = (width*((i+weekday)%columns));
        NSInteger offsetY = (width *((i+weekday)/columns));
        [button1 setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];//----后一个width改为
        [button1.layer setBorderColor:[[UIColor brownColor] CGColor]];
        [button1.layer setBorderWidth:0.0];//---------2.0 改为 0.0
 
#pragma mark-------------本月日期的边界线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor brownColor];//--------------brownColor 改 clearColor
        
#pragma mark -----------确定今天的日期
        if(button1.tag ==_today){
            todayLable.frame=CGRectMake( button1.frame.origin.x, button1.frame.origin.y, width, width);
            [todayLable.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
            todayLable.backgroundColor=[UIColor whiteColor];
            todayLable.alpha=0.3;
            [self addSubview:todayLable];
        
            [button1 setBackgroundColor:[UIColor whiteColor]];  //----显示当天日期
            [button1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        }
        button1.layer.cornerRadius=(kScreenWidth-20)/14;
        button1.layer.masksToBounds=YES;
        [self addSubview:button1];
        
#pragma mark  -------给日程添加标示
        if(_dateListArray.count != 0){
            for(NSInteger i=0;i<_dateListArray.count;i++){
                NSString *yearStr=[[_dateListArray[i] objectForKey:@"startDate"] substringWithRange:NSMakeRange(0, 4)];
                NSString *monthStr=[[_dateListArray[i] objectForKey:@"startDate"] substringWithRange:NSMakeRange(5, 2)];
                NSString *dayStr=[[_dateListArray[i] objectForKey:@"startDate"] substringWithRange:NSMakeRange(8, 2)];
                if(button1.tag==[dayStr integerValue] && components.month == [monthStr integerValue] && components.year == [yearStr integerValue]){
                    
                    remindInfoimageview=[[UIImageView alloc]initWithFrame:CGRectMake(button1.frame.origin.x+width/2-3, button1.frame.origin.y+width-10, 4, 4)];
                    
                    remindInfoimageview.layer.cornerRadius=2;
                    remindInfoimageview.layer.masksToBounds=YES;
                    remindInfoimageview.backgroundColor=[UIColor colorWithRed:0 green:1 blue:1 alpha:1];
                    remindInfoimageview.layer.anchorPoint=CGPointMake(0.5, 0.5);
                    [self addSubview:remindInfoimageview];
                }
            }
            
        }
    }
 
#pragma mark------------------------------------------以前的日期
    NSDateComponents *previousMonthComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    previousMonthComponents.month -=1;
    NSDate *previousMonthDate = [gregorian dateFromComponents:previousMonthComponents];
    NSRange previousMonthDays = [c rangeOfUnit:NSCalendarUnitDay
                   inUnit:NSCalendarUnitMonth
                  forDate:previousMonthDate];
    NSInteger maxDate = previousMonthDays.length - weekday;
    
    for (int i=0; i<weekday; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.text = [NSString stringWithFormat:@"%d",maxDate+i+1];
        [button setTitle:[NSString stringWithFormat:@"%d",maxDate+i+1] forState:UIControlStateNormal];
        NSInteger offsetX = (width*(i%columns));
        NSInteger offsetY = (width *(i/columns));
        [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
        [button.layer setBorderWidth:2.0];
        [button.layer setBorderColor:[[UIColor clearColor] CGColor]]; //---框--brownColor  改为 clearColor
        UIView *columnView = [[UIView alloc]init];
        [columnView setBackgroundColor:[UIColor clearColor]];  //--竖线---brownColor  改为 clearColor
        if(i==0)
        {
            [columnView setFrame:CGRectMake(0, 0, 4, button.frame.size.width)];
            [button addSubview:columnView];
        }

        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:[UIColor clearColor]];  //--横线---brownColor  改为 clearColor
        [lineView setFrame:CGRectMake(0, 0, button.frame.size.width, 4)];
        [button addSubview:lineView];
        [button setTitleColor:[UIColor colorWithRed:229.0/255.0 green:231.0/255.0 blue:233.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
        [button setEnabled:NO];
        [self addSubview:button];
    }

#pragma mark -------------------------------下个月的日期
    NSInteger remainingDays = (monthLength + weekday) % columns;
    if(remainingDays >0){
        for (int i=remainingDays; i<columns; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.text = [NSString stringWithFormat:@"%d",(i+1)-remainingDays];
            [button setTitle:[NSString stringWithFormat:@"%d",(i+1)-remainingDays] forState:UIControlStateNormal];
            NSInteger offsetX = (width*((i) %columns));
            NSInteger offsetY = (width *((monthLength+weekday)/columns));
            [button setFrame:CGRectMake(originX+offsetX, originY+40+offsetY, width, width)];
            [button.layer setBorderWidth:2.0];
            [button.layer setBorderColor:[[UIColor clearColor] CGColor]];  //----以后日期 框 -brownColor  改为 clearColor
            UIView *columnView = [[UIView alloc]init];
            [columnView setBackgroundColor:[UIColor clearColor]]; //----以后日期  竖线--brownColor  改为 clearColor
            if(i==columns - 1)
            {
                [columnView setFrame:CGRectMake(button.frame.size.width-4, 0, 4, button.frame.size.width)];
                [button addSubview:columnView];
            }
            UIView *lineView = [[UIView alloc]init];
            [lineView setBackgroundColor:[UIColor clearColor]];  //----以后日期  横线---brownColor  改为 clearColor
            [lineView setFrame:CGRectMake(0, button.frame.size.width-4, button.frame.size.width, 4)];
            [button addSubview:lineView];
            [button setTitleColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
            [button setEnabled:NO];
            [self addSubview:button];

        }
    }

}


#pragma mark ---------日期点击事件
-(IBAction)tappedDate:(UIButton *)sender
{
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    
 //--------------------------
    if(!(_selectedDate == sender.tag && _selectedMonth == [components month] && _selectedYear == [components year])){
        UIButton *previousSelected =(UIButton *) [self viewWithTag:_selectedDate];
        if(_selectedDate != -1){
            
            [previousSelected setBackgroundColor:[UIColor clearColor]];
            [previousSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }
        
        [sender setBackgroundColor:[UIColor whiteColor]];   //选择日期的的背景色
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _selectedDate = sender.tag;
        
        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        components.day = _selectedDate;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        
        clickedDate = [gregorian dateFromComponents:components];
        [self.delegate tappedOnDate:clickedDate titleString:dateString];
        
    }
}


#pragma mark --左滑手势
-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 2;
    components.month += 1;

    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    
  
    dateString = [[format stringFromDate:self.calendarDate] uppercaseString];

     [self.delegate tappedOnDate:self.calendarDate titleString:dateString];
}

#pragma mark --右滑手势
-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
   

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
    components.day = 2;
    components.month -= 1;

    self.calendarDate = [gregorian dateFromComponents:components];
    [UIView transitionWithView:self
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
    
    dateString = [[format stringFromDate:self.calendarDate] uppercaseString];
    
    
    
    [self.delegate tappedOnDate:self.calendarDate titleString:dateString];
}


-(void)setCalendarParameters
{
    if(gregorian == nil)
    {
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.calendarDate];
        _selectedDate  = components.day;
        _selectedMonth = components.month;
        _selectedYear = components.year;
        
        _today =components.day;
        _todayMonth =components.month;
        _todayYear =components.year;

    }
}

@end
