

#import <UIKit/UIKit.h>


@protocol CalendarDelegate <NSObject>

-(void)tappedOnDate:(NSDate *)selectedDate titleString:(NSString *)str;

@end

@interface CalendarView : UIView
{
    NSInteger _selectedDate;
    NSArray *_weekNames;
}

@property (nonatomic,strong) NSDate *calendarDate;
@property (nonatomic,weak) id<CalendarDelegate> delegate;

//-----------------接收日程提醒列表
@property(strong,nonatomic)NSArray *dateListArray;


@end
