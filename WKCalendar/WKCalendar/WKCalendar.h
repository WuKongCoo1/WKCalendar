//
//  WKCalendar.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WKDayView.h"
#import "WKCalendarDefine.h"


extern NSString * const dayBtnClickedNotification;
@class WKCalendar;
@protocol  WKCalendarDelegate <NSObject>

- (void)calendar:(WKCalendar *)calendar selectDate:(NSDate *)date;

@end

@protocol WKCalendarDataSource <NSObject>

- (NSArray *)calendar:(WKCalendar *)calendar;

@end


@interface WKCalendar : UIView <WKDayViewProtocol>

- (void)createCalendarViewWith:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;


@property (nonatomic, assign) WKCalendarType type;
@property (nonatomic, assign) id<WKCalendarDataSource> dataSource;
@property (nonatomic, assign) id<WKCalendarDelegate> delegate;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) WKDayView *selectDayView;


@end
