//
//  DateManager.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "DateManager.h"
#import "XingZuoDate.h"
#import "NSDate+String.h"

@interface DateManager () {
    NSCalendar* _chineseCalendar;
    NSArray* chineseYears;
    NSArray* chineseMonths;
    NSArray* chineseDays;
    NSArray* weekDays;
    NSArray<NSString*>* _shortWeekStrings;
    NSArray<NSString*>* _shengXiao;
    NSArray<XingZuoDate*>* _xingZuo;
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
//        self.calendar.firstWeekday = WEEK_DAY_MONDAY;
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
    _shengXiao = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    /**
     十二星座的划分日期
     *  白羊座：3月21日～4月19日
     　　金牛座：4月20日～5月20日
     　　双子座：5月21日～6月21日
     　　巨蟹座：6月22日～7月22日
     　　狮子座：7月23日～8月22日
     　　处女座：8月23日～9月22日
     　　天秤座：9月23日～10月23日
     　　天蝎座：10月24日～11月22日
     　　射手座：11月23日～12月21日
     　　摩羯座：12月22日～1月19日
     　　水瓶座：1月20日～2月18日
     　　双鱼座：2月19日～3月20日
     */
//    _xingZuo = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
    
//    [self _setupXingZuo];
}

//- (XingZuoDate*)_buildXingZuo:(NSString*)name start:(NSDate*)st end:(NSDate*)ed {
//    XingZuoDate* xz = [XingZuoDate new];
//    xz.name = name;
//    xz.start = st;
//    xz.end = ed;
//    return xz;
//}
//
//- (void)_setupXingZuo {
//    NSMutableArray* mary = [NSMutableArray array];
//    
//    [mary addObject:[self _buildXingZuo:@"白羊座" start:[NSDate hy_dateFromMDString:@"3月21日"] end:[NSDate hy_dateFromMDString:@"4月19日"]]];
//    [mary addObject:[self _buildXingZuo:@"金牛座" start:[NSDate hy_dateFromMDString:@"4月20日"] end:[NSDate hy_dateFromMDString:@"5月20日"]]];
//    [mary addObject:[self _buildXingZuo:@"双子座" start:[NSDate hy_dateFromMDString:@"5月21日"] end:[NSDate hy_dateFromMDString:@"6月21日"]]];
//    [mary addObject:[self _buildXingZuo:@"巨蟹座" start:[NSDate hy_dateFromMDString:@"6月22日"] end:[NSDate hy_dateFromMDString:@"7月22日"]]];
//    [mary addObject:[self _buildXingZuo:@"狮子座" start:[NSDate hy_dateFromMDString:@"7月23日"] end:[NSDate hy_dateFromMDString:@"8月22日"]]];
//    [mary addObject:[self _buildXingZuo:@"处女座" start:[NSDate hy_dateFromMDString:@"8月23日"] end:[NSDate hy_dateFromMDString:@"9月22日"]]];
//    [mary addObject:[self _buildXingZuo:@"天秤座" start:[NSDate hy_dateFromMDString:@"9月23日"] end:[NSDate hy_dateFromMDString:@"10月23日"]]];
//    [mary addObject:[self _buildXingZuo:@"天蝎座" start:[NSDate hy_dateFromMDString:@"10月24日"] end:[NSDate hy_dateFromMDString:@"11月22日"]]];
//    [mary addObject:[self _buildXingZuo:@"射手座" start:[NSDate hy_dateFromMDString:@"11月23日"] end:[NSDate hy_dateFromMDString:@"12月21日"]]];
//    [mary addObject:[self _buildXingZuo:@"摩羯座" start:[NSDate hy_dateFromMDString:@"12月22日"] end:[NSDate hy_dateFromMDString:@"1月19日"]]];
//    [mary addObject:[self _buildXingZuo:@"水瓶座" start:[NSDate hy_dateFromMDString:@"1月20日"] end:[NSDate hy_dateFromMDString:@"2月18日"]]];
//    [mary addObject:[self _buildXingZuo:@"双鱼座" start:[NSDate hy_dateFromMDString:@"2月19日"] end:[NSDate hy_dateFromMDString:@"3月20日"]]];
//    
//    _xingZuo = mary;
//}

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

// 获取十二生肖表示的中国年
- (NSString*)getShengXiao:(NSDate*)date {
    NSDateComponents *cmp = [_chineseCalendar components:NSCalendarUnitYear fromDate:date];
    NSInteger year = cmp.year-1;
    NSInteger modIndex = year % 12;
    return _shengXiao[modIndex];
}
// 获取星座
- (NSString*)getXingZuo:(NSDate*)date {
    NSString* retStr = nil;
    
    NSDateComponents *cmp = [self.calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger i_month = cmp.month;
    NSInteger i_day = cmp.day;
    
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    
    return retStr;
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
    NSString *y_str = [chineseYears objectAtIndex:cmp.year-1];
    NSLog(@"%@", y_str);
    NSString *m_str = [chineseMonths objectAtIndex:cmp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:cmp.day-1];
    NSString* w_str = [weekDays objectAtIndex:cmp.weekday-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@ %@",m_str,d_str, w_str];
    return chineseCal_str;
}

@end
