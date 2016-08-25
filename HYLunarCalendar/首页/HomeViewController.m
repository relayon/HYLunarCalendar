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
#import "CalendarDisplayCell.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate> {
    int weekPerMonth;
    int dayPerWeek;
    int _pageIndex;
    NSDate* _nowDate;
    
    NSDate* _minDate;
    NSDate* _maxDate;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionViewHeight;
- (IBAction)onTodayClicked:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _minDate = [NSDate hy_dateFromDefaultString:@"1901-1-1 00:00:00"];
//    _maxDate = [NSDate hy_dateFromDefaultString:@"2099-12-31 00:00:00"];
//    _nowDate = [NSDate date];
    _minDate = [NSDate hy_dateFromDefaultString:@"2016-1-1 00:00:00"];
    _maxDate = [NSDate hy_dateFromDefaultString:@"2016-12-31 00:00:00"];
//    _nowDate = [NSDate hy_dateFromDefaultString:@"2016-2-1 00:00:00"];
    _nowDate = [NSDate date];
    _pageIndex = 0;
    weekPerMonth = 6;
    dayPerWeek = 7;
    [self setupCollectionView];
    [self setupTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollToDate:_nowDate animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDate*)_getCurrentDateWithPage:(NSInteger)page {
    NSDate* dt = [[DateManager sharedInstance] dateWithDate:_minDate monthOffset:page];
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

- (void)scrollToDate:(NSDate*)date animated:(BOOL)animated {
    NSInteger months = [[DateManager sharedInstance] monthsFromDate:_minDate toDate:date];
    CGFloat width = self.view.frame.size.width;
    CGFloat ofx = width * months;
    [self.collectionView setContentOffset:CGPointMake(ofx, 0) animated:animated];
}

/**
 *  根据月偏移更新日期标题
 *
 *  @param offset 月偏移量
 */
- (void)updateTitleWithMonthOffset:(NSInteger)offset {
    NSDate* nDate = [[DateManager sharedInstance] dateWithDate:_minDate monthOffset:offset];
    NSString* tTitle = [nDate hy_stringYearMonth];
    self.title = tTitle;
}

#pragma mark - setup collection view
- (void)setupCollectionView {
    CGFloat width = self.view.frame.size.width;
    CGFloat wd = width/dayPerWeek;
    CGFloat ht = wd * weekPerMonth;
    self.layoutCollectionViewHeight.constant = ht;
//    self.collectionView.contentSize = CGSizeMake(width*3, ht);
    
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

#pragma mark - setup tableview 
- (void)setupTableView {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* cellName = NSStringFromClass([CalendarDisplayCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:mainBundle] forCellReuseIdentifier:cellName];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = self.layoutCollectionViewHeight.constant;
    self.tableView.contentInset = insets;
}

#pragma mark --
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
    NSInteger months = [[DateManager sharedInstance] monthsFromDate:_minDate toDate:_maxDate] + 1;
    return months;
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

/**
 *  点击选中Cell
 *
 *  @param collectionView
 *  @param indexPath
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate* date = [self _dateWithIndex:indexPath];
    NSLog(@"select data = %@", [date hy_stringDefault]);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s -- {%ld, %ld}", __FUNCTION__, indexPath.section, indexPath.row);
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        NSLog(@"collection view");
        CGFloat offsetx = scrollView.contentOffset.x;
        CGFloat width = scrollView.frame.size.width;
        int page = (offsetx + width/2)/width;
        _pageIndex = page;
        [self updateTitleWithMonthOffset:page];
    } else {
        NSLog(@"table view");
    }
    
}

#pragma mark - UITableViewDataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    
    NSString* cellName = NSStringFromClass([CalendarDisplayCell class]);
    CalendarDisplayCell* tCell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    cell = tCell;
    
    return cell;
}

//---------------------------------------------------------------------------------------
- (IBAction)onTodayClicked:(UIBarButtonItem *)sender {
    [self scrollToDate:_nowDate animated:YES];
}
@end
