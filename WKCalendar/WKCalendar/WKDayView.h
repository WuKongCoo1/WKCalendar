//
//  DayView.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DayViewType) {
    DayViewTypeCurrentMonth = 0,
    DayViewTypeLastMonth,
    DayViewTypeNextMonth
};

@class WKDayView;

@protocol WKDayViewProtocol <NSObject>

- (void)WKDayViewSelected:(WKDayView *)dayView;

@end

@interface WKDayView : UIView

@property (nonatomic, strong) UIButton *dayBtn;
@property (nonatomic, strong) NSDate *date;
@property (weak, nonatomic) UIView *dayListView;
@property (assign, nonatomic) id<WKDayViewProtocol> delegate;
@property (assign, nonatomic) DayViewType type;

- (void)btnClicked:(UIButton *)sender;

- (void)setStyle_HaveHomework;
- (void)setStyle_AfterToday;
- (void)setStyle_Today;
- (void)setStyle_BeforeToday;
//- (void)setStyle_BeyondThisMonth;
- (void)setStyleNextMonth;
- (void)setStyleLastMonth;
- (void)setTitle:(NSString *)title;
- (void)changeState;
- (void)setStyle_NoHomework;
- (void)setStyle_Normal;
- (void)setStyle_FillColor;
@end
