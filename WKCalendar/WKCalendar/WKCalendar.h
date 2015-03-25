//
//  WKCalendar.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WKDayView.h"
extern NSString * const dayBtnClickedNotification;
@class WKCalendar;
@protocol  WKCalendarDelegate<NSObject>

- (void)calendar:(WKCalendar *)calendar selectDate:(NSDate *)date;

@end

@interface WKCalendar : UIView <WKDayViewProtocol>

- (void)createCalendarViewWith:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, assign) id<WKCalendarDelegate> delegate;

@end
