//
//  WKDayListView.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKDayListView.h"
#import "WKDayView.h"
#import "WKCalendarDefine.h"

@implementation WKDayListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    _calendar = (WKCalendar *)newSuperview;
}

- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //设定每周的第一天从周日开始
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (void)setDate:(NSDate*)date selectedDay:(NSInteger)selectedDay
{
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 7;
    // 2.创建星期头
    UIView *weekBg = [self createWeekDayLabelWithItemWidth:itemW itemHeight:itemH];
    
    // 3.创建每一天的视图
    [self createDayViewsDate:date weekBgView:weekBg itemWidth:itemW itemHeight:itemH selectedDay:selectedDay];
}

/**
 *  创建日期Label
 *
 *  @param itemW 宽
 *  @param itemH gao
 *
 *  @return 日期label父视图View
 */
- (UIView *)createWeekDayLabelWithItemWidth:(CGFloat)itemW itemHeight:(CGFloat)itemH
{
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor clearColor];
    weekBg.frame = CGRectMake(0, 0, self.frame.size.width, itemH);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:18];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = RGB(43, 173, 195);
        [weekBg addSubview:week];
    }
    
    return weekBg;
}

- (void)createDayViewsDate:(NSDate *)date weekBgView:(UIView *)weekBg itemWidth:(CGFloat)itemW itemHeight:(CGFloat)itemH selectedDay:(NSInteger)selectedDay
{
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        WKDayView *dayView = [[WKDayView alloc] initWithFrame:CGRectMake(x, y, itemW, itemH)];
        dayView.delegate = _calendar;
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {//上个月的
            day = daysInLastMonth - firstWeekday + i + 1;
            
            dayView.tag = day;
            dayView.date = [self lastMonth:date];
            
            [dayView setStyleLastMonth];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){//下个月的
            day = i + 1 - firstWeekday - daysInThisMonth;
            dayView.tag = day;
            dayView.date = [self nextMonth:date];
            
            [dayView setStyleNextMonth];
        }else{//本月的
            
            day = i - firstWeekday + 1;
            dayView.tag = day;
            dayView.date = date;
            
            if (self.type == WKCalendarTypeWithoutDataSource) {//没有特殊标志的
                
                [self setDayViewCanSelected:dayView day:day selectedDay:selectedDay];
                
            }else if (self.type == WKCalendarTypeWithDataSource){//有特殊标志的
                
                if ([_calendar.dataSource respondsToSelector:@selector(calendar:)]) {
                    
                    NSArray *arr = [_calendar.dataSource calendar:self.calendar];
                    
                    [self setupDayView:dayView dataSource:arr day:day selectedDay:selectedDay];
                    
                }else{//没有数据源
                    [dayView setStyle_Normal];
                }
                
            }
            
        }
        
        [dayView setTitle:[NSString stringWithFormat:@"%ld", day]];
        dayView.tag = day;
        
        [self addSubview:dayView];
    }
}

/**
 *  根据数组设置dayView的特殊状态
 *
 *  @param dayView     日期View
 *  @param day         号
 *  @param selectedDay 当前选中的天数
 */
- (void)setDayViewCanSelected:(WKDayView *)dayView day:(NSInteger)day selectedDay:(NSInteger)selectedDay
{
    [dayView setStyle_Normal];
    
    //判断当前选中
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dayViewDayStr = [df stringFromDate:dayView.date];
    
    NSString *nowDateDayStr = [df stringFromDate:[NSDate date]];
    df.dateFormat = @"yyyy-MM";
    NSString *nowDateMonthStr = [df stringFromDate:[NSDate date]];
    NSString *dayViewMonthStr = [df stringFromDate:dayView.date];
    
    if ([nowDateMonthStr compare:dayViewMonthStr] == NSOrderedSame) {//同一个月
        if ([nowDateDayStr isEqualToString:dayViewDayStr]) {
            [dayView setStyle_FillColor];
            dayView.dayBtn.selected = YES;
            _calendar.selectDayView = dayView;
        }
        
        if (day == selectedDay) {
            dayView.dayBtn.selected = YES;
            _calendar.selectDayView = dayView;
        }
        
    }else{//不同一个月
        if (day == (selectedDay ? selectedDay : DefaultDay)) {
            dayView.dayBtn.selected = YES;
            _calendar.selectDayView = dayView;
        }
    }

}







- (void)setupDayView:(WKDayView *)dayView dataSource:(NSArray *)dataSource day:(NSInteger)day selectedDay:(NSInteger)selectedDay
{
    BOOL state = NO;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dayViewDayStr = [df stringFromDate:dayView.date];
    
    
    for (NSString *dateStr in dataSource) {
        
        for (int i = 0; i < 10; i++) {
            
            if ([dayViewDayStr isEqualToString:dateStr]) { //有特殊状态
                state = YES;
            }
        }
        
    }
    if (state) { //有
        [dayView setStyle_FillColor];
    }else{//没有
        [dayView setStyle_Normal];
    }
    
    NSString *nowDateDayStr = [df stringFromDate:[NSDate date]];
    df.dateFormat = @"yyyy-MM";
    NSString *nowDateMonthStr = [df stringFromDate:[NSDate date]];
    NSString *dayViewMonthStr = [df stringFromDate:dayView.date];
    if ([nowDateMonthStr compare:dayViewMonthStr] == NSOrderedSame) {//同一个月
        if ([nowDateDayStr isEqualToString:dayViewDayStr]) {
            dayView.dayBtn.selected = YES;
            _calendar.selectDayView = dayView;
        }
        
    }else{//不同一个月
        
        if (day == (selectedDay ? selectedDay : DefaultDay)) {
            dayView.dayBtn.selected = YES;
            _calendar.selectDayView = dayView;
        }
    }
}

@end
