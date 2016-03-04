//
//  DayView.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKDayView.h"
#import "WKCalendarDefine.h"
#define BTN_WH 30

NSString * const dayBtnClickedNotification = @"dayBtnClickedNotification";
@implementation WKDayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        CGRect btnF = CGRectMake(0, 0, BTN_WH, BTN_WH);
        CGPoint point = CGPointMake((frame.size.width - btnF.size.width) / 2, (frame.size.height - btnF.size.height) / 2);
        btnF.origin = point;
        _dayBtn.frame = btnF;

        _dayBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _dayBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_dayBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_dayBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_dayBtn addTarget:self action:@selector(highlighted:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_dayBtn];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    _dayListView = newSuperview;
}

#pragma mark - date button style

- (void)setStyleLastMonth
{
    self.type = DayViewTypeLastMonth;
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setStyleNextMonth
{
    self.type = DayViewTypeNextMonth;
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setStyle_BeforeToday
{
    
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setStyle_Today
{
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_dayBtn setBackgroundColor:[UIColor orangeColor]];
}

- (void)setStyle_AfterToday
{
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}



- (void)setTitle:(NSString *)title
{
    [_dayBtn setTitle:title forState:UIControlStateNormal];
}

- (void)btnClicked:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(WKDayViewSelected:)]) {
        [self.delegate WKDayViewSelected:self];
    }
}

- (void)changeState
{
    _dayBtn.selected = !_dayBtn.selected;
}

- (void)setStyle_NoHomework
{
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"wating"] forState:UIControlStateSelected];
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _dayBtn.layer.masksToBounds = YES;
}

- (void)setStyle_HaveHomework
{
    _dayBtn.enabled = YES;
    _dayBtn.layer.borderColor = RGB(43, 173, 195).CGColor;
    _dayBtn.layer.borderWidth = 1.0f;
    [_dayBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"choose_on"] forState:UIControlStateSelected];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"choose_on"]forState:UIControlStateHighlighted];
    [_dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _dayBtn.layer.masksToBounds = YES;
}

- (void)setStyle_Normal
{
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"selected_bg"] forState:UIControlStateSelected];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"selected_bg"]forState:UIControlStateHighlighted];
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _dayBtn.layer.masksToBounds = YES;
}

- (void)setStyle_FillColor
{
    _dayBtn.enabled = YES;
    [_dayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"choose_on"] forState:UIControlStateNormal];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"choose_on"] forState:UIControlStateSelected];
    [_dayBtn setBackgroundImage:[UIImage imageNamed:@"choose_on"]forState:UIControlStateHighlighted];
    [_dayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    _dayBtn.layer.masksToBounds = YES;
}

- (void)highlighted:(UIButton *)sender
{
    sender.highlighted = NO;
}

- (void)setDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateStr = [df stringFromDate:date];
    NSMutableString *firstDayStr = [dateStr mutableCopy];
    [firstDayStr replaceCharactersInRange:NSMakeRange(8, 2) withString:[NSString stringWithFormat:@"%02ld", self.tag]];
    NSDate *firstDate = [df dateFromString:firstDayStr];
    
    NSDate *realDate;
    realDate = [[NSDate alloc] initWithTimeInterval:24 * 60 * 60 * (self.tag - 1)sinceDate:firstDate];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: firstDate];
    
    NSDate *localeDate = [firstDate  dateByAddingTimeInterval: interval];

    _date = localeDate;
}

@end
