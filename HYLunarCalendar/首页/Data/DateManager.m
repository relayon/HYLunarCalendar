//
//  DateManager.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "DateManager.h"

@interface DateManager () {
    NSCalendar* _chineseCalendar;
    NSArray* chineseYears;
    NSArray* chineseMonths;
    NSArray* chineseDays;
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
        [self initChineseCalendar];
    }
    return self;
}

- (void)initChineseCalendar {
    _chineseCalendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese]; // 农历
    chineseYears = [NSArray arrayWithObjects:
                             @"甲子",   @"乙丑",  @"丙寅",  @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑",  @"戊寅",  @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸卯",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
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

// 是否在同一个月
- (BOOL)isDate:(NSDate*)dateA inSameMonthWithDate:(NSDate*)dateB {
    NSDateComponents *cmpA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *cmpB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    return cmpA.year == cmpB.year && cmpA.month == cmpB.month;
}

/**
 *  农历
 */
- (NSString*)getChineseCalendarWithDate:(NSDate *)date{
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |\
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmp = [_chineseCalendar components:unitFlags fromDate:date];
    NSString *y_str = [chineseYears objectAtIndex:cmp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:cmp.month-1];
    NSString *d_str;
    NSInteger dayIndex = cmp.day-1;
    if (dayIndex == 0) {
        // 把 “初一” 替换为 月份
        d_str = m_str;
    } else {
        d_str = [chineseDays objectAtIndex:dayIndex];
    }
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    NSLog(@"%@", chineseCal_str);
    return d_str;
}

@end
