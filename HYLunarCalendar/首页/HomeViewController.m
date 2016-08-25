//
//  HomeViewController.m
//  HYLunarCalendar
//
//  Created by SMC-MAC on 16/8/24.
//  Copyright © 2016年 heyou. All rights reserved.
//

#import "HomeViewController.h"
#import "HYCalendarCell.h"
#import "DateManager.h"
#import "NSDate+String.h"
#import "HYCalendarHeader.h"
#import "HYCalendarLayout.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate> {
    int weekPerMonth;
    int dayPerWeek;
    int _pageIndex;
    NSDate* _nowDate;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionViewHeight;
- (IBAction)onTodayClicked:(UIBarButtonItem *)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _nowDate = [NSDate date];
    _pageIndex = 0;
    weekPerMonth = 6;
    dayPerWeek = 7;
    [self setupCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate*)_getCurrentDateWithPage:(NSInteger)page {
    NSDate* dt = [[DateManager sharedInstance] dateWithDate:_nowDate monthOffset:page];
    return dt;
}

- (NSDate*)_dateWithIndex:(NSIndexPath*)indexPath {
    NSDate* tDate;
    
    NSInteger row = indexPath.row % weekPerMonth;
    NSInteger col = indexPath.row / weekPerMonth;
    NSIndexPath* tIndex = [NSIndexPath indexPathForRow:row inSection:col];
    NSDate* currentDate = [self _getCurrentDateWithPage:indexPath.section];
    tDate = [[DateManager sharedInstance] dateWithDate:currentDate weekIndex:tIndex];
    
    return tDate;
}

/**
 *  根据月偏移更新日期标题
 *
 *  @param offset 月偏移量
 */
- (void)updateTitleWithMonthOffset:(NSInteger)offset {
    NSDate* nDate = [[DateManager sharedInstance] dateWithDate:_nowDate monthOffset:offset];
    NSString* tTitle = [nDate hy_stringYearMonth];
    self.title = tTitle;
}

#pragma mark - setup collection view
- (void)setupCollectionView {
    CGFloat width = self.view.frame.size.width;
    CGFloat wd = width/dayPerWeek;
    CGFloat ht = wd * weekPerMonth;
    self.layoutCollectionViewHeight.constant = ht;
    
    // 注册自定义的Cell
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* cellName = NSStringFromClass([HYCalendarCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:cellName bundle:mainBundle] forCellWithReuseIdentifier:cellName];
    // 触摸延迟
    self.collectionView.delaysContentTouches = NO;
    // 布局
    HYCalendarLayout* layout = [HYCalendarLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    
    // 添加Header
    HYCalendarHeader* calendarHeader = [[HYCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    [self.view addSubview:calendarHeader];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat wd = self.collectionView.frame.size.width/dayPerWeek;
//    CGFloat ht = (self.collectionView.frame.size.height - 64) / weekPerMonth;
    CGFloat ht = wd;
    return CGSizeMake(wd, ht);
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 6周
    return weekPerMonth*dayPerWeek;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = nil;
    // 使用自定义Cell，也可以在StoryBoard中添加
    // 自定义的Cell耦合性较低，便于复用
    NSString* cellName = NSStringFromClass([HYCalendarCell class]);
    HYCalendarCell* tCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    NSDate* date = [self _dateWithIndex:indexPath];
    NSDate* currentDate = [self _getCurrentDateWithPage:indexPath.section];
    [tCell setDate:date currentDate:currentDate];
//    tCell.labelTitle.text = [date hy_stringDay];
    
//    NSInteger row = indexPath.row % weekPerMonth;
//    NSInteger col = indexPath.row / weekPerMonth;
//    tCell.labelTitle.text = [NSString stringWithFormat:@"%ld, %ld", row, col];
    
    cell = tCell;
    
    return cell;
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetx = scrollView.contentOffset.x;
    CGFloat width = scrollView.frame.size.width;
    int page = (offsetx + width/2)/width;
    _pageIndex = page;
    [self updateTitleWithMonthOffset:page];
}

- (IBAction)onTodayClicked:(UIBarButtonItem *)sender {
}
@end
