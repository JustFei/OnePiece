//
//  MonthContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MonthContentView.h"
#import "MonthDataView.h"
#import "FMDBTool.h"
#import "MonthDataView.h"
#import "SportModel.h"
#import "HooDatePicker.h"

#define DEFAULT_COLOR [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]

@interface MonthContentView () < UICollectionViewDelegate ,UICollectionViewDataSource, HooDatePickerDelegate>
{
    NSInteger _rowCount;
}
@property (nonatomic ,weak) UIButton *leftButton;
@property (nonatomic ,weak) UIButton *centerDateButton;
@property (nonatomic ,strong) UIButton *calendarButton;
@property (nonatomic ,weak) UIButton *rightButton;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,assign) BOOL didEndDecelerating;
@property (nonatomic ,strong) HooDatePicker *datePicker;

@end

@implementation MonthContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews
{
    self.leftButton.frame = XXF_CGRectMake(20, 7, 44, 44);
    DLog(@"month == %f",kViewCenter.x);
    self.centerDateButton.frame = XXF_CGRectMake(kViewCenter.x - kViewWidth - 60, self.leftButton.center.y - 15, 120, 30);
    self.calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.calendarButton.frame = XXF_CGRectMake(self.centerDateButton.frame.origin.x + 125, self.centerDateButton.center.y - 11.5 , 25, 23);
    self.calendarButton.contentMode = UIViewContentModeCenter;
    [self.calendarButton setImage:[UIImage imageNamed:@"Calendar"] forState:UIControlStateNormal];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTheCalender:)];
    [self.calendarButton addTarget:self action:@selector(showTheCalender:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.calendarButton];
    self.rightButton.frame = XXF_CGRectMake(kViewWidth - 64, 7, 44, 44);
    self.rightButton.enabled = NO;
    if (self.dataArr.count == 1) {
        self.leftButton.enabled = NO;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(kViewWidth, kViewHeight - self.centerDateButton.frame.origin.y - 50);
    
    //2.初始化collectionView
    self.collectionView  = [[UICollectionView alloc] initWithFrame:XXF_CGRectMake(0, 50, kViewWidth, kViewHeight - self.centerDateButton.frame.origin.y - 50) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = kClearColor;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerNib:[UINib nibWithNibName:@"MonthDataView" bundle:nil] forCellWithReuseIdentifier:@"monthCell"];
    self.collectionView.contentOffset = CGPointMake(9 * kViewWidth, 0);
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.monthArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthDataView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
    cell.backgroundColor = kClearColor;
    MonthHistoryModel *model = self.dataArr[indexPath.row];
    
    cell.model = model;
    return cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.didEndDecelerating = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    @autoreleasepool {
        self.didEndDecelerating = YES;
        CGFloat index = scrollView.contentOffset.x/kViewWidth;
        int i = roundf(index);
        [self.centerDateButton setTitle:self.monthArr[i] forState:UIControlStateNormal];
        if (i == self.monthArr.count - 1) {
            self.rightButton.enabled = NO;
        }else {
            self.rightButton.enabled = YES;
        }
        
        if (i == 0) {
            self.leftButton.enabled = NO;
        }else {
            self.leftButton.enabled = YES;
        }
    }
}

// 如果没有，四舍五入手动确定位置。这样就可以解决滑动过快的问题
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (!self.didEndDecelerating) {
        // 先计算当期的page/index
        CGFloat index = scrollView.contentOffset.x/kViewWidth;
        int i = roundf(index);
        [self.centerDateButton setTitle:self.monthArr[i] forState:UIControlStateNormal];
    }
}

//当 setContentOffset 结束的时候
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    @autoreleasepool {
        self.didEndDecelerating = YES;
        CGFloat index = scrollView.contentOffset.x/kViewWidth;
        int i = roundf(index);
        [self.centerDateButton setTitle:self.monthArr[i] forState:UIControlStateNormal];
        if (i == self.monthArr.count - 1) {
            self.rightButton.enabled = NO;
        }else {
            self.rightButton.enabled = YES;
        }
        
        if (i == 0) {
            self.leftButton.enabled = NO;
        }else {
            self.leftButton.enabled = YES;
        }
    }
}

#pragma mark - Action
- (void)beforeDay:(UIButton *)sender
{
    CGFloat index = self.collectionView.contentOffset.x/kViewWidth;
    int i = roundf(index);
    if (i != 0) {
        [self.collectionView setContentOffset:CGPointMake((i - 1) * kViewWidth, 0) animated:YES];
        [self.centerDateButton setTitle:self.monthArr[i - 1] forState:UIControlStateNormal];
        if (i == 1) {
            sender.enabled = NO;
        }
        self.rightButton.enabled = YES;
    }
}

- (void)afterDay:(UIButton *)sender
{
    CGFloat index = self.collectionView.contentOffset.x/kViewWidth;
    int i = roundf(index);
    if (i != self.dataArr.count - 1) {
        [self.collectionView setContentOffset:CGPointMake((i + 1) * kViewWidth, 0) animated:YES];
        [self.centerDateButton setTitle:self.monthArr[i + 1] forState:UIControlStateNormal];
        if (i == self.monthArr.count - 2) {
            sender.enabled = NO;
        }
        self.leftButton.enabled = YES;
    }
}

- (void)showTheCalender:(UIButton *)sender
{
    _rowCount = -1;

    self.datePicker = [[HooDatePicker alloc] initWithSuperView:[self findViewController:self].view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [self.datePicker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];   //让时区正确
    NSDate *maxDate = [NSDate date];
    NSDate *minDate = [dateFormatter dateFromString:self.monthArr.firstObject];
    self.datePicker.minimumDate = minDate;//设置显示的最小日期
    self.datePicker.maximumDate = maxDate;//设置显示的最大日期
    [self.datePicker setTintColor:DEFAULT_COLOR];//设置主色
    [self.datePicker setHighlightColor:[UIColor blackColor]];//设置高亮颜色
    //默认日期一定要最后设置，否在会被覆盖成当天的日期
    [self.datePicker setDate:[dateFormatter dateFromString:self.centerDateButton.titleLabel.text] animated:YES];//设置默认日期
    
    [self.datePicker show];
}

#pragma mark - HooDatePickerDelegate
- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date
{
    DLog(@"%@",datePicker.date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *currentDateString = [formatter stringFromDate:datePicker.date];
    
    [self.monthArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:currentDateString]) {
            _rowCount = (int)idx;
        }
    }];
}

- (void)datePicker:(HooDatePicker *)datePicker didCancel:(UIButton *)sender
{
    [datePicker dismiss];
}

- (void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM"];

    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
    NSString *currentDateString = [formatter stringFromDate:date];
    [self.monthArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:currentDateString]) {
            _rowCount = (int)idx;
        }
    }];
    if (_rowCount != -1) {
        [self.collectionView setContentOffset:CGPointMake(_rowCount * kViewWidth, 0) animated:YES];
        [self.centerDateButton setTitle:self.monthArr[_rowCount] forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (UIButton *)leftButton
{
    if (!_leftButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(beforeDay:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _leftButton = button;
    }
    
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Right"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(afterDay:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _rightButton = button;
    }
    
    return _rightButton;
}

- (UIButton *)centerDateButton
{
    if (!_centerDateButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.monthArr.lastObject forState:UIControlStateNormal];
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showTheCalender:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _centerDateButton = button;
    }
    
    return _centerDateButton;
}

- (NSMutableArray *)monthArr
{
    if (!_monthArr) {
        _monthArr = [NSMutableArray array];
    }
    
    return _monthArr;
}

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    
    return _dataArr;
}

#pragma mark - 获取当前View的控制器的方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
