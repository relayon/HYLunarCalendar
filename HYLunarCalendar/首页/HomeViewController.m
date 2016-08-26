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
#import "HYDatePicker.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    int weekPerMonth;
    int dayPerWeek;
    int _pageIndex;
//    NSDate* _nowDate;
    
    NSDate* _minDate;
    NSDate* _maxDate;
    CGFloat _originY;
    NSDate* _selectDate;
}
@property (weak, nonatomic) UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCollectionViewHeight;
@property (assign, nonatomic) CGFloat mMonthCalendarHeight;
@property (assign, nonatomic) CGFloat mWeekCalendarHeight;
- (IBAction)onTodayClicked:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonTitle;
- (IBAction)onTitleClicked:(UIButton *)sender;

@property (weak, nonatomic) UIView* mCalendarContainer;
@property (assign, nonatomic) CGFloat mContainerHeight;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _minDate = [NSDate hy_dateFromDefaultString:@"1901-1-1 00:00:00"];
//    _maxDate = [NSDate hy_dateFromDefaultString:@"2099-12-31 00:00:00"];
//    _nowDate = [NSDate date];
    _minDate = [NSDate hy_dateFromDefaultString:@"2016-1-1 00:00:00"];
    _maxDate = [NSDate hy_dateFromDefaultString:@"2018-12-31 00:00:00"];
//    _nowDate = [NSDate hy_dateFromDefaultString:@"2016-2-1 00:00:00"];
//    _nowDate = [NSDate date];
    _selectDate = [self _getNowDate];
    _pageIndex = 0;
    weekPerMonth = 6;
    dayPerWeek = 7;
    _originY = 30.0f;
    [self setupCollectionView];
    [self setupTableView];
}

- (NSDate*)_getNowDate {
    return [NSDate date];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [self scrollToDate:_nowDate animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取当前 page 月的第一天
 */
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
//    self.title = tTitle;
    [self.buttonTitle setTitle:tTitle forState:UIControlStateNormal];
}

#pragma mark - setup collection view
- (void)setupCollectionView {
    CGFloat width = self.view.frame.size.width;
    CGFloat wd = width/dayPerWeek;
    CGFloat ht = wd * weekPerMonth;
    ht = ceilf(ht);
    self.mMonthCalendarHeight = ht;
    self.mWeekCalendarHeight = ceilf(wd);
    
    // add container
    UIView* calendarContainer = [UIView new];
    calendarContainer.backgroundColor = [UIColor redColor];
    self.mContainerHeight = ht + _originY;
    calendarContainer.frame = CGRectMake(0, 0, width, self.mContainerHeight);
    [self.view addSubview:calendarContainer];
    self.mCalendarContainer = calendarContainer;
    
    // 布局
    HYCalendarLayout* layout = [HYCalendarLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect tFrame = CGRectMake(0, _originY, width, ht);
    UICollectionView* cv = [[UICollectionView alloc] initWithFrame:tFrame collectionViewLayout:layout];
    cv.pagingEnabled = YES;
    cv.showsHorizontalScrollIndicator = NO;
    cv.backgroundColor = [UIColor lightGrayColor];
    cv.dataSource = self;
    cv.delegate = self;
    // 触摸延迟
    cv.delaysContentTouches = NO;
    
    // 注册自定义的Cell
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* cellName = NSStringFromClass([HYCalendarCell class]);
    [cv registerNib:[UINib nibWithNibName:cellName bundle:mainBundle] forCellWithReuseIdentifier:cellName];
//    [self.view addSubview:cv];
    [self.mCalendarContainer addSubview:cv];
    self.collectionView = cv;
    
    // 添加双击手势, 会导致单击选中的延迟
//    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
//    [tapRecognizer setNumberOfTapsRequired:2];
//    [self.collectionView addGestureRecognizer:tapRecognizer];
    
    // 添加Header
    HYCalendarHeader* calendarHeader = [[HYCalendarHeader alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
//    [self.view addSubview:calendarHeader];
    [self.mCalendarContainer addSubview:calendarHeader];
    
    [self scrollToDate:[self _getNowDate] animated:NO];
    
    // 添加手势
//    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
////    panGesture.delegate = self;
//    [self.mCalendarContainer addGestureRecognizer:panGesture];
}

#pragma mark -- handlePanGesture 
- (void)handlePanGesture:(UIPanGestureRecognizer*)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self panDidBegan:panGesture];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self panDidChange:panGesture];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self panDidEnd:panGesture];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self panDidEnd:panGesture];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            [self panDidEnd:panGesture];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)panDidBegan:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
}

- (void)panDidChange:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    NSLog(@"{%f, %f}", translation, velocity);
    
    CGFloat delta = -translation;
    delta = MAX(delta, 0.0f);   // 最小
    delta = MIN(delta, self.mMonthCalendarHeight - self.mWeekCalendarHeight);   // 最大
    CGRect tFrame = self.collectionView.frame;
    tFrame.origin.y = _originY - delta;
    self.collectionView.frame = tFrame;
    
    // change container frame;
    CGRect containerFrame = self.mCalendarContainer.frame;
    containerFrame.size.height = self.mContainerHeight - delta;
    self.mCalendarContainer.frame = containerFrame;
    
    // set tableview content offset
    CGPoint offset = self.tableView.contentOffset;
    offset.y = -self.mMonthCalendarHeight + delta;
    self.tableView.contentOffset = offset;
}

- (void)panDidEnd:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark -- 

#pragma -- handleTapGesture
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath* indexPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
        if (indexPath!=nil) {
            NSLog(@"click @ {%ld, %ld}", indexPath.section, indexPath.row);
            NSDate* date = [self _dateWithIndex:indexPath];
            NSLog(@"double click date = %@", [date hy_stringDefault]);
        } else {
            NSLog(@"no cell clicked");
        }
    }
}

#pragma mark - setup tableview 
- (void)setupTableView {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* cellName = NSStringFromClass([CalendarDisplayCell class]);
    [self.tableView registerNib:[UINib nibWithNibName:cellName bundle:mainBundle] forCellReuseIdentifier:cellName];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = self.mMonthCalendarHeight;
    self.tableView.contentInset = insets;
    
    self.tableView.tableFooterView = [UIView new];
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
    _selectDate = date;
    NSLog(@"select data = %@", [date hy_stringDefault]);
    [self.tableView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s -- {%ld, %ld}", __FUNCTION__, indexPath.section, indexPath.row);
}

#pragma mark - UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
//        NSLog(@"collection view");
        // 按月更新标题
        CGFloat offsetx = scrollView.contentOffset.x;
        CGFloat width = scrollView.frame.size.width;
        int page = (offsetx + width/2)/width;
        _pageIndex = page;
        [self updateTitleWithMonthOffset:page];
    } else if (scrollView == self.tableView) {
//        NSLog(@"table view");
        // TableView和CollectionView联动
        // 当TableView的Cell数量较小时，无法拖动到顶部
        // TODO://
#if 0
        CGFloat ofy = scrollView.contentOffset.y;
        CGFloat delta = self.mMonthCalendarHeight + ofy;
//        NSLog(@"offset = %f, delta = %f", ofy, delta);
        delta = MAX(delta, 0.0f);   // 最小
        delta = MIN(delta, self.mMonthCalendarHeight - self.mWeekCalendarHeight);   // 最大
        CGRect tFrame = self.collectionView.frame;
        tFrame.origin.y = _originY - delta;
        self.collectionView.frame = tFrame;
        
        // change container frame
        CGRect containerFrame = self.mCalendarContainer.frame;
        containerFrame.size.height = self.mContainerHeight - delta;
        self.mCalendarContainer.frame = containerFrame;
        // content insets
//        UIEdgeInsets insets = self.tableView.contentInset;
//        insets.top = self.mMonthCalendarHeight - delta;
//        self.tableView.contentInset = insets;
#endif
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s, decelerate = %@", __FUNCTION__, decelerate?@"YES":@"NO");
}

#pragma mark - UITableViewDataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = nil;
    
    NSString* cellName = NSStringFromClass([CalendarDisplayCell class]);
    CalendarDisplayCell* tCell = [tableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        tCell.labelTitle.text = [_selectDate hy_stringYearMonthDay];
    } else {
        tCell.labelTitle.text = [[DateManager sharedInstance] getChineseCalendarMDWWithDate:_selectDate];
    }
//    tCell.labelSubTitle.text = [[DateManager sharedInstance] getChineseCalendarDefaultStringWithDate:_selectDate];
    cell = tCell;
    
    return cell;
}

//---------------------------------------------------------------------------------------
- (IBAction)onTodayClicked:(UIBarButtonItem *)sender {
    [self scrollToDate:[self _getNowDate] animated:YES];
}

- (IBAction)onTitleClicked:(UIButton *)sender {
//    [[HYDatePicker create] show:NO];
}
@end
