//
//  HYCalendarCell.h
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCalendarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelSubTitle;

// 设置当前日期
- (void)setDate:(NSDate*)date currentDate:(NSDate*)currentDate;

@end
