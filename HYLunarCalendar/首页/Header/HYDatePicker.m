//
//  HYDatePicker.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/26.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "HYDatePicker.h"

@interface HYDatePicker ()
@property (weak, nonatomic) UIDatePicker* datePicker;
@property (assign, nonatomic) BOOL mAnimated;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation HYDatePicker

+ (HYDatePicker*)create {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    HYDatePicker* picker = [[HYDatePicker alloc] initWithFrame:window.bounds];
    return picker;
}

- (void)show:(BOOL)animated {
    self.mAnimated = animated;
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    if (self.mAnimated) {
        CGRect sFrame = self.datePicker.frame;
        CGRect eFrame = sFrame;
        sFrame.origin.y = -sFrame.size.height;
        self.datePicker.frame = sFrame;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.datePicker.frame = eFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

#pragma mark -- init date picker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mAnimated = NO;
        NSString* nibName = NSStringFromClass([HYDatePicker class]);
        self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
        self.backgroundView.alpha = 0.5f;
        [self _setupDatePicker];
        [self _addTapGuesture];
    }
    return self;
}

#pragma mark - setup date picker
- (void)_setupDatePicker {
    CGFloat width = self.frame.size.width;
    CGFloat height = 216;
//    CGFloat py = (self.frame.size.height - height)/2.0f;
    CGFloat py = 64.0f;
    UIDatePicker* dPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, py, width, height)];
    dPicker.backgroundColor = [UIColor whiteColor];
    dPicker.datePickerMode = UIDatePickerModeDate;
    [dPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [self addSubview:dPicker];
    self.datePicker = dPicker;
}

#pragma mark - add guesture
- (void)_addTapGuesture {
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)handleTapGuesture:(UITapGestureRecognizer*)gesture {
    if (self.mAnimated) {
        CGRect tFrame = self.datePicker.frame;
        tFrame.origin.y = -tFrame.size.height;
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.datePicker.frame = tFrame;
                         } completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    } else {
        [self removeFromSuperview];
    }
}

@end
