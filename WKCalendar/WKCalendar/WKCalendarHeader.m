//
//  WKCalendarHeader.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "WKCalendarHeader.h"
#import "WKCalendarDefine.h"

@implementation WKCalendarHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat heigth = self.frame.size.height;
        
        _timeLbl = [[UILabel alloc] init];
//        _timeLbl.text     = [NSString stringWithFormat:@"%li年%li月",[self year:date],[self month:date]];
        _timeLbl.font     = [UIFont systemFontOfSize:18];
        _timeLbl.frame           = CGRectMake(0, 0, self.frame.size.width, heigth);
        _timeLbl.textAlignment   = NSTextAlignmentCenter;
        _nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextMonthBtn.frame = CGRectMake(self.bounds.size.width - kMargin - kNextBtnWidth, (heigth - KNextBtnHeight) / 2, kNextBtnWidth, KNextBtnHeight);
        [_nextMonthBtn setBackgroundImage:[UIImage imageNamed:@"nextMonthBg"] forState:UIControlStateNormal];
        
        
        
        _lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastMonthBtn.frame = CGRectMake(kMargin, (heigth - KNextBtnHeight) / 2, kNextBtnWidth, KNextBtnHeight);
        [_lastMonthBtn setBackgroundImage:[UIImage imageNamed:@"lastMonthBg"] forState:UIControlStateNormal];

        [self addSubview: _timeLbl];
        [self addSubview:_nextMonthBtn];
        [self addSubview:_lastMonthBtn];
    }
    return self;
}

- (void)setTime:(NSString *)str
{
    _timeLbl.text = str;
}

- (void)setNextMonthBtnTarget:(id)target action:(SEL)action
{
    [_nextMonthBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLastMonthBtnTarget:(id)target action:(SEL)action
{
    [_lastMonthBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
