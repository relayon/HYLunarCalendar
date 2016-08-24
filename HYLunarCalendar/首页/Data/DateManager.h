//
//  DateManager.h
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
// 当前月的第一天
- (NSDate*)firstDayOfMonth:(NSDate*)date;
// 当前周的第一天
- (NSDate*)firstDayOfWeek:(NSDate*)date;
// 当前月，按周索引日期
- (NSDate*)dateWithDate:(NSDate*)date weekIndex:(NSIndexPath*)indexPath;
// 农历
- (NSString*)getChineseCalendarWithDate:(NSDate *)date;
// 是否在同一个月
- (BOOL)isDate:(NSDate*)dateA inSameMonthWithDate:(NSDate*)dateB;

@end
