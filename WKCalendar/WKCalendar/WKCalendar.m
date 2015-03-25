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
#import "WKCalendarDefine.h"


@implementation WKCalendar
{
    WKDayView *_selectDayView;
    NSMutableArray *_daysArray;
    WKDayListView *_dayListView;
    WKCalendarHeader *_headerView;
    BOOL isAwakeFromNib;
}

- (void)awakeFromNib
{
    isAwakeFromNib = YES;
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
#warning 修改，不用通知用代理
    }
    return self;
}

- (void)layoutSubviews
{
    if (isAwakeFromNib) {
        [self setDate:[NSDate date]];
        isAwakeFromNib = NO;
    }

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

#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSDate *)date{
    
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
    [self addSubview:_dayListView];
    [_dayListView setDate:_date];
}

#pragma mark - WKDayViewDelegate
- (void)WKDayViewSelected:(WKDayView *)dayView
{

    if (_selectDayView != dayView) {
        [_selectDayView changeState];
        
        _selectDayView = dayView;
        
        [_selectDayView changeState];
        
        if ([self.delegate respondsToSelector:@selector(calendar:selectDate:)]) {
            [self.delegate calendar:self selectDate:dayView.date];
        }
    }
}

- (void)btnAction:(id)sender
{
    if (sender == _headerView.nextMonthBtn) {
        
        _headerView.nextMonthBtn.enabled = NO;
        
        CGRect newF = _dayListView.frame;
        newF.origin.x += _dayListView.bounds.size.width;
        WKDayListView *newDayList = [[WKDayListView alloc] initWithFrame:newF];
        
        _date = [self nextMonth:self.date];
        [self addSubview:newDayList];
        [newDayList setDate:_date];
        [self updateTime];
        [UIView animateWithDuration:0.8f animations:^{
            _dayListView.transform = CGAffineTransformTranslate(_dayListView.transform, -_dayListView.bounds.size.width, 0);
            newDayList.transform = CGAffineTransformTranslate(newDayList.transform, -newDayList.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            _headerView.nextMonthBtn.enabled = YES;
            [_dayListView removeFromSuperview];
            
            _dayListView = newDayList;
        }];
       
        
    }else if (sender == _headerView.lastMonthBtn){

        _headerView.lastMonthBtn.enabled = NO;
        CGRect newF = _dayListView.frame;
        newF.origin.x -= _dayListView.bounds.size.width;
        WKDayListView *newDayList = [[WKDayListView alloc] initWithFrame:newF];
        
        _date = [self lastMonth:self.date];
        [self addSubview:newDayList];
        [newDayList setDate:_date];
        [self updateTime];
        [UIView animateWithDuration:0.8f animations:^{
            _dayListView.transform = CGAffineTransformTranslate(_dayListView.transform, _dayListView.bounds.size.width, 0);
            newDayList.transform = CGAffineTransformTranslate(newDayList.transform, newDayList.bounds.size.width, 0);
        } completion:^(BOOL finished) {
            _headerView.lastMonthBtn.enabled = YES;
            [_dayListView removeFromSuperview];
            
            _dayListView = newDayList;
        }];
        
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
