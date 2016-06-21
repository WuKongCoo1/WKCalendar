//
//  WKCalendar.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKCalendar.h"
#import "WKDayView.h"
#import "WKDayListView.h"
#import "WKCalendarHeader.h"



@implementation WKCalendar
{
    NSMutableArray *_daysArray;
    WKDayListView *_dayListView;
    WKDayListView *_newDayListView;
    WKDayListView *_oldDayListView;
    WKCalendarHeader *_headerView;
    BOOL isAwakeFromNib;
}

- (void)awakeFromNib
{
    isAwakeFromNib = YES;
    _date = [NSDate date];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            
            [_daysArray addObject:button];
        }
        [self setDate:[NSDate date]];

    }
    return self;
}


- (void)layoutSubviews
{
    if (isAwakeFromNib) {
        [self setDate:[NSDate date]];
        isAwakeFromNib = NO;
    }
    
    self.userInteractionEnabled = YES;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
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
    [calendar setFirstWeekday:1];
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

- (NSInteger)dateInCurrentMonthDay:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"dd";
    
    NSString *dayString = [df stringFromDate:date];
    
    return [dayString integerValue];
}

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
    
    [self addSwipeGesture];
}

- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGes:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGes:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipe];
}

- (void)swipeGes:(UISwipeGestureRecognizer *)swipeGes
{
    switch (swipeGes.direction) {
        case UISwipeGestureRecognizerDirectionRight: {
            [self showLastMonthWithSelectedDay:0];
            break;
        }
        case UISwipeGestureRecognizerDirectionLeft: {
            
            [self showNextMonthWithSelectedDay:0];
            break;
        }
        default:{
            break;
        }
    }
}

- (void)showNextMonthWithSelectedDay:(NSInteger)selectedDay
{
    CGRect newF = _dayListView.frame;
    newF.origin.x += _dayListView.bounds.size.width;
    _newDayListView = [[WKDayListView alloc] initWithFrame:newF];
    _newDayListView.type = self.type;
    _date = [self nextMonth:self.date];
    [self addSubview:_newDayListView];

    [_newDayListView setDate:_date selectedDay:selectedDay];
    [self updateTime];
    
    [UIView animateWithDuration:0.8f animations:^{
        _dayListView.transform = CGAffineTransformTranslate(_dayListView.transform, -_dayListView.bounds.size.width, 0);
        _newDayListView.transform = CGAffineTransformTranslate(_newDayListView.transform, -_newDayListView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        [_oldDayListView removeFromSuperview];
    }];
    _oldDayListView = _dayListView;
    _dayListView = _newDayListView;
}

- (void)showLastMonthWithSelectedDay:(NSInteger)selectedDay
{
    CGRect newF = _dayListView.frame;
    newF.origin.x -= _dayListView.bounds.size.width;
    _newDayListView = [[WKDayListView alloc] initWithFrame:newF];
    _newDayListView.type = self.type;
    _date = [self lastMonth:self.date];
    [self addSubview:_newDayListView];
    [_newDayListView setDate:_date selectedDay:selectedDay];
    [self updateTime];
    [UIView animateWithDuration:0.8f animations:^{
        _dayListView.transform = CGAffineTransformTranslate(_dayListView.transform, _dayListView.bounds.size.width, 0);
        _newDayListView.transform = CGAffineTransformTranslate(_newDayListView.transform, _newDayListView.bounds.size.width, 0);
    } completion:^(BOOL finished) {
        
        [_oldDayListView removeFromSuperview];
        
    }];
    _oldDayListView = _dayListView;
    _dayListView = _newDayListView;
}

- (void)createCalendarViewWith:(NSDate *)date{
    _date = date;
    CGFloat itemH     = self.frame.size.height / 8;
    
    //header
    _headerView = [[WKCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, itemH)];
    NSString *timeStr = [NSString stringWithFormat:@"%li年%li月",[self year:date],[self month:date]];
    [_headerView setTime:timeStr];
    [_headerView setNextMonthBtnTarget:self action:@selector(btnAction:)];
    [_headerView setLastMonthBtnTarget:self action:@selector(btnAction:)];
    [self addSubview:_headerView];
    
    //listView
    _dayListView = [[WKDayListView alloc] initWithFrame:CGRectMake(0, itemH, self.frame.size.width, itemH * 7)];
    _dayListView.type = self.type;
    [self addSubview:_dayListView];
    [_dayListView setDate:_date selectedDay:0];
}

#pragma mark - WKDayViewDelegate
- (void)WKDayViewSelected:(WKDayView *)dayView
{

    if (_selectDayView != dayView) {
        
        switch (dayView.type) {
            case DayViewTypeCurrentMonth: {
                [_selectDayView changeState];
                
                _selectDayView = dayView;
                
                [_selectDayView changeState];
                break;
            }
            case DayViewTypeLastMonth: {
                [self showLastMonthWithSelectedDay:dayView.tag];
                break;
            }
            case DayViewTypeNextMonth: {
                [self showNextMonthWithSelectedDay:dayView.tag];
                break;
            }
        }
        
        
        _date = dayView.date;
        if ([self.delegate respondsToSelector:@selector(calendar:selectDate:)]) {
            [self.delegate calendar:self selectDate:dayView.date];
        }
    }
}

- (void)btnAction:(id)sender
{
    if (sender == _headerView.nextMonthBtn) {
        
        [self showNextMonthWithSelectedDay:0];
       
        
    }else if (sender == _headerView.lastMonthBtn){

        [self showLastMonthWithSelectedDay:0];
    }
}

#pragma mark - 更新时间
- (void)updateTime
{
    [_headerView setTime:[NSString stringWithFormat:@"%li年%li月",[self year:_date],[self month:_date]]];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
