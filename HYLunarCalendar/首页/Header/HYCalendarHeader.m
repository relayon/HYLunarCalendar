//
//  HYCalendarHeader.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/25.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "HYCalendarHeader.h"
#import "HYCalendarHeaderCell.h"

@interface HYCalendarHeader() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    int dayPerWeek;
    NSArray* _weekStrings;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HYCalendarHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"HYCalendarHeader" owner:self options:nil] firstObject];
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = frame;
        
        _weekStrings = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
        // 注册自定义的Cell
        NSBundle* mainBundle = [NSBundle mainBundle];
        NSString* cellName = NSStringFromClass([HYCalendarHeaderCell class]);
        [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:mainBundle] forCellWithReuseIdentifier:cellName];
        // 触摸延迟
        self.collectionView.delaysContentTouches = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        dayPerWeek = 7;
    }
    return self;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wd = self.frame.size.width/dayPerWeek;
    CGFloat ht = self.frame.size.height;
    return CGSizeMake(wd, ht);
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dayPerWeek;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;
    // 自定义的Cell耦合性较低，便于复用
    NSString* cellName = NSStringFromClass([HYCalendarHeaderCell class]);
    HYCalendarHeaderCell* tCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    tCell.labelTitle.text = _weekStrings[indexPath.row];
    cell = tCell;
    
    return cell;
}

@end
