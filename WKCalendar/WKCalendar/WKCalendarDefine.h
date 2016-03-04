//
//  WKCalendarDefine.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#ifndef WKCalendar_WKCalendarDefine_h
#define WKCalendar_WKCalendarDefine_h

#define DefaultDay 1
#define RGB(r, g, b) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0]

#define kNextBtnWidth 17
#define KNextBtnHeight 25
#define kMargin 20

typedef enum WKCalendarType{
    WKCalendarTypeWithoutDataSource = 0, //没有需要特殊标志的日期
    WKCalendarTypeWithDataSource //需要特殊标志的日期
}WKCalendarType;
#endif
