//
//  NSDate+String.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

/**
 *  获取年月字符串，例：2016年8月
 *
 *  @return 年月
 */
- (NSString*)hy_stringYearMonth {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy年M月"];
    return [fmt stringFromDate:self];
}

/**
 *  获取年月日字符串，例：2016年8月23日
 *
 *  @return 年月日
 */
- (NSString*)hy_stringYearMonthDay {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy年M月d日"];
    return [fmt stringFromDate:self];
}

/**
 *  默认时间格式字符串，例：2016年8月24日 18:33:06
 *
 *  @return 默认时间格式字符串
 */
- (NSString*)hy_stringDefault {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy-M-d HH:mm:ss"];
    return [fmt stringFromDate:self];
}

/**
 *  获取天
 *
 *  @return
 */
- (NSString*)hy_stringDay {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"d"];
    return [fmt stringFromDate:self];
}

/**
 *  默认格式日期字符串转NSDate
 *
 *  @param defaultString
 *
 *  @return
 */
+ (NSDate*)hy_dateFromDefaultString:(NSString*)defaultString {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy-M-d HH:mm:ss"];
    return [fmt dateFromString:defaultString];
}

/**
 *  月日字符串转NSDate, 例：8-24
 *
 *  @param 月日
 *
 *  @return
 */
+ (NSDate*)hy_dateFromMDString:(NSString*)mdStr {
    NSDateFormatter* fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"M月d日"];
    return [fmt dateFromString:mdStr];
}

@end
