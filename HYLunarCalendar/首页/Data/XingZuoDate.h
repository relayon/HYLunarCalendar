//
//  XingZuoDate.h
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/26.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XingZuoDate : NSObject

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) NSDate* start;
@property (strong, nonatomic) NSDate* end;

- (BOOL)contain:(NSDate*)date;

@end
