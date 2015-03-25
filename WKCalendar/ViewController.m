//
//  ViewController.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "ViewController.h"
#import "WKCalendar.h"
@interface ViewController ()<WKCalendarDelegate, WKCalendarDataSource>
@property (weak, nonatomic) IBOutlet WKCalendar *calendar;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.type = WKCalendarTypeWithDataSource;
    
}

- (void)calendar:(WKCalendar *)calendar selectDate:(NSDate *)date
{
    NSLog(@"%@", date);
}

- (NSArray *)calendar:(WKCalendar *)calendar
{
    _dataSource = [NSMutableArray array];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    for (int i = 0; i < 10; i++) {
        NSDate *lateDate = [[NSDate date] laterDate:[NSDate date]];
        NSString *str = [df stringFromDate:lateDate];
        [_dataSource addObject:str];
    }
    return _dataSource;
}

@end
