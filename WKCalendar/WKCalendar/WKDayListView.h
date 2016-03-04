//
//  WKDayListView.h
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKCalendar.h"
@interface WKDayListView : UIView

@property (nonatomic, weak) WKCalendar *calendar;
@property (nonatomic, assign) WKCalendarType type;

- (void)setDate:(NSDate*)date selectedDay:(NSInteger)selectedDay;

@end
