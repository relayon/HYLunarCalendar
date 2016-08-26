//
//  HYCalendarCell.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "HYCalendarCell.h"
#import "NSDate+String.h"
#import "DateManager.h"

@implementation HYCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIView* sv = [UIView new];
    sv.backgroundColor = [UIColor redColor];
    self.selectedBackgroundView = sv;
}

// 设置当前日期
- (void)setDate:(NSDate*)date currentDate:(NSDate*)currentDate {
    self.backgroundColor = [UIColor lightGrayColor];
    self.labelTitle.text = [date hy_stringDay];
    self.labelSubTitle.text = [[DateManager sharedInstance] getChineseCalendarDayWithDate:date];
    
    BOOL inSameMonth = [[DateManager sharedInstance] isDate:date inSameMonthWithDate:currentDate];
    if (inSameMonth) {
        [self _styleSameMonth];
        NSDate* nowDate = [NSDate date];
        BOOL inSameDay = [[DateManager sharedInstance] isDate:date inSameDayWithDate:nowDate];
        if (inSameDay) {
            self.backgroundColor = [UIColor orangeColor];
        }
    } else {
        [self _styleDiffMonth];
    }
}

- (void)_styleSameMonth {
    self.labelTitle.textColor = [UIColor blackColor];
    self.labelSubTitle.textColor = [UIColor blackColor];
}

- (void)_styleDiffMonth {
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelSubTitle.textColor = [UIColor whiteColor];
}

@end
