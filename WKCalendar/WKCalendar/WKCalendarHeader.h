//
//  WKCalendarHeader.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKCalendarHeader : UIView

@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UIButton *nextMonthBtn;
@property (nonatomic, strong) UIButton *lastMonthBtn;

- (void)setTime:(NSString *)str;
- (void)setNextMonthBtnTarget:(id)target action:(SEL)action;
- (void)setLastMonthBtnTarget:(id)target action:(SEL)action;
@end
