//
//  XingZuoDate.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/26.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "XingZuoDate.h"
#import "DateManager.h"

@implementation XingZuoDate

- (BOOL)contain:(NSDate*)date {
    NSCalendar* calendar = [DateManager sharedInstance].calendar;
    
    NSDateComponents *cmp = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    NSInteger month = cmp.month;
    NSInteger day = cmp.day;
    
//    NSDateComponents *cmp = [calendar components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
//    NSInteger month = cmp.month;
//    NSInteger day = cmp.day;
    
    return NO;
}

@end
