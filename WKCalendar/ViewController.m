//
//  ViewController.m
//  WKCalendar
//
//  Created by 吴珂 on 15/3/25.
//  Copyright (c) 2015年 吴珂. All rights reserved.
//

#import "ViewController.h"
#import "WKCalendar.h"
@interface ViewController ()<WKCalendarDelegate>
@property (weak, nonatomic) IBOutlet WKCalendar *calendar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _calendar.delegate = self;
    
}

- (void)calendar:(WKCalendar *)calendar selectDate:(NSDate *)date
{
    NSLog(@"%@", date);
}


@end
