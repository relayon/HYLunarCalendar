//
//  DateManager.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "DateManager.h"

@interface DateManager () {
    
}

@end

@implementation DateManager
/**
 *  单例
 *
 *  @return 实例对象
 */
+ (instancetype)sharedInstance {
    //Singleton instance
    static DateManager *dateInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateInstance = [[self alloc] init];
    });
    
    return dateInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]; // 阳历
    }
    return self;
}

// 月偏移后的日期
- (NSDate*)dateWithDate:(NSDate*)date monthOffset:(NSInteger)offset {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    cmp.month += offset;
    NSDate* nDate = [self.calendar dateFromComponents:cmp];
    
    return nDate;
}
// 当前月的第一天
- (NSDate*)firstDayOfMonth:(NSDate*)date {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSDate* nDate = [self.calendar dateFromComponents:cmp];
    
    return nDate;
}
// 当前周的第一天
- (NSDate*)firstDayOfWeek:(NSDate*)date {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth fromDate:date];
    cmp.weekday = self.calendar.firstWeekday + 1;
    NSDate* nDate = [self.calendar dateFromComponents:cmp];
    
    return nDate;
}

// 当前月，按周索引日期
- (NSDate*)dateWithDate:(NSDate*)date weekIndex:(NSIndexPath*)indexPath {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfMonth fromDate:date];
    cmp.weekOfMonth = indexPath.row + 1;
    cmp.weekday = self.calendar.firstWeekday + indexPath.section;
    NSDate* nDate = [self.calendar dateFromComponents:cmp];
    return nDate;
}

@end
