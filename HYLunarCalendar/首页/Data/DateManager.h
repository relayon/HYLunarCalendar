//
//  DateManager.h
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  定义每周的第一天是星期几，1：周日，2：周一
 */
typedef NS_ENUM(NSInteger,WEEK_DAY) {
    /**
     *  周日
     */
    WEEK_DAY_SUNDAY = 1,
    /**
     *  周一
     */
    WEEK_DAY_MONDAY = 2,
    /**
     *  周二
     */
    WEEK_DAY_TUESDAY = 3,
    /**
     *  周三
     */
    WEEK_DAY_WEDNESDAY = 4,
    /**
     *  周四
     */
    WEEK_DAY_THURSDAY = 5,
    /**
     *  周五
     */
    WEEK_DAY_FRIDAY = 6,
    /**
     *  周六
     */
    WEEK_DAY_SATURDAY = 7
    
};

@interface DateManager : NSObject
/**
 *  单例
 *
 *  @return 实例对象
 */
+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSCalendar* calendar;

// 月偏移后的日期
- (NSDate*)dateWithDate:(NSDate*)date monthOffset:(NSInteger)offset;
// 获取两个时间段之间的月数
- (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
// 当前月的第一天
- (NSDate*)firstDayOfMonth:(NSDate*)date;
// 当前周的第一天
- (NSDate*)firstDayOfWeek:(NSDate*)date;
// 当前月，按周索引日期
- (NSDate*)dateWithDate:(NSDate*)date weekIndex:(NSIndexPath*)indexPath;
// 获取农历日期，例： 初八
- (NSString*)getChineseCalendarDayWithDate:(NSDate *)date;
// 获取农历年月日，例： 甲子年 八月 初八
- (NSString*)getChineseCalendarDefaultStringWithDate:(NSDate *)date;
// 获取农历月日星期，例： 八月初八 星期二
- (NSString*)getChineseCalendarMDWWithDate:(NSDate *)date;
// 是否在同一个月
- (BOOL)isDate:(NSDate*)dateA inSameMonthWithDate:(NSDate*)dateB;
// 是否在同一天
- (BOOL)isDate:(NSDate*)dateA inSameDayWithDate:(NSDate*)dateB;
// 获取星期字符串
- (NSArray<NSString*>*)getWeekdayStrings;
// index = 0 开始，获取星期字符串
- (NSString*)getShortWeekString:(NSInteger)index;
// 获取十二生肖表示的中国年
- (NSString*)getShengXiao:(NSDate*)date;
// 获取星座
- (NSString*)getXingZuo:(NSDate*)date;
@end
