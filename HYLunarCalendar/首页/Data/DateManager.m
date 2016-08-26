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
    NSArray* weekDays;
    NSArray<NSString*>* _shortWeekStrings;
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
//        NSInteger tIndex = self.calendar.firstWeekday;
        self.calendar.firstWeekday = 2;
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
    
    weekDays = @[@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    _shortWeekStrings = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
}

// 获取星期字符串
- (NSArray<NSString*>*)getWeekdayStrings {
    return weekDays;
}

// index = 0 开始，获取星期字符串
- (NSString*)getShortWeekString:(NSInteger)index {
    NSInteger tIndex = index + self.calendar.firstWeekday - 1;
    tIndex = tIndex % 7;
    return _shortWeekStrings[tIndex];
}

// 月偏移后的日期
- (NSDate*)dateWithDate:(NSDate*)date monthOffset:(NSInteger)offset {
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond fromDate:date];
    cmp.month += offset;
    NSDate* nDate = [self.calendar dateFromComponents:cmp];
    
    return nDate;
}
// 获取两个时间段之间的月数
- (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitMonth
                                                    fromDate:fromDate
                                                      toDate:toDate
                                                     options:0];
    return components.month;
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

// 是否在同一天
- (BOOL)isDate:(NSDate*)dateA inSameDayWithDate:(NSDate*)dateB {
    NSDateComponents *cmpA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *cmpB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    return cmpA.year == cmpB.year && cmpA.month == cmpB.month && cmpA.day == cmpB.day;
}

/**
 *  农历
 */
- (NSString*)getChineseCalendarDayWithDate:(NSDate *)date{
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

// 获取农历年月日，例： 甲子年 八月 初八
- (NSString*)getChineseCalendarDefaultStringWithDate:(NSDate *)date {
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |\
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmp = [_chineseCalendar components:unitFlags fromDate:date];
    NSString *y_str = [chineseYears objectAtIndex:cmp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:cmp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:cmp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@ %@ %@",y_str,m_str,d_str];
    return chineseCal_str;
}

// 获取农历月日星期，例： 八月初八 星期二
- (NSString*)getChineseCalendarMDWWithDate:(NSDate *)date {
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |\
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *cmp = [_chineseCalendar components:unitFlags fromDate:date];
    NSString *m_str = [chineseMonths objectAtIndex:cmp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:cmp.day-1];
    NSString* w_str = [weekDays objectAtIndex:cmp.weekday-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@ %@",m_str,d_str, w_str];
    return chineseCal_str;
}

@end
