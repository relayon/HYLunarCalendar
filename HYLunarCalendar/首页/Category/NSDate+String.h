//
//  NSDate+String.h
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

/**
 *  获取年月字符串，例：2016年8月
 *
 *  @return 年月
 */
- (NSString*)hy_stringYearMonth;
/**
 *  获取年月日字符串，例：2016年8月23日
 *
 *  @return 年月日
 */
- (NSString*)hy_stringYearMonthDay;

/**
 *  默认时间格式字符串，例：2016-8-24 18:33:06
 *
 *  @return 默认时间格式字符串
 */
- (NSString*)hy_stringDefault;

/**
 *  获取天
 *
 *  @return
 */
- (NSString*)hy_stringDay;

/**
 *  默认格式日期字符串转NSDate
 *
 *  @param defaultString
 *
 *  @return
 */
+ (NSDate*)hy_dateFromDefaultString:(NSString*)defaultString;

/**
 *  月日字符串转NSDate, 例：8-24
 *
 *  @param 月日
 *
 *  @return
 */
+ (NSDate*)hy_dateFromMDString:(NSString*)mdStr;

@end
