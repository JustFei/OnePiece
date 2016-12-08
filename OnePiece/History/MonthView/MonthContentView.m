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


@interface MonthContentView () < UICollectionViewDelegate ,UICollectionViewDataSource >

@property (nonatomic ,weak) UIButton *leftButton;
@property (nonatomic ,weak) UIButton *centerDateButton;
@property (nonatomic ,strong) UIImageView *calendarImageView;
@property (nonatomic ,weak) UIButton *rightButton;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,copy) NSString *currentDateString;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) NSMutableArray *dataArr;


@end

@implementation MonthContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        self.currentDateString = [formatter stringFromDate:[NSDate date]];
        
        self.dataArr = [NSMutableArray arrayWithArray: [self.myFmdbTool queryStepWithDate:nil]];
    }
    return self;
}

- (void)layoutSubviews
{
    self.leftButton.frame = XXF_CGRectMake(25, 31, 14, 24);
    DLog(@"month == %f",kViewCenter.x);
    self.centerDateButton.frame = XXF_CGRectMake(kViewCenter.x - kViewWidth - 60, self.leftButton.center.y - 15, 120, 30);
    
    self.calendarImageView = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(self.centerDateButton.frame.origin.x + 130, self.centerDateButton.frame.origin.y , 34, 30)];
    
    self.calendarImageView.image = [UIImage imageNamed:@"Calendar"];
    [self addSubview:self.calendarImageView];
    self.rightButton.frame = XXF_CGRectMake(kViewWidth - 32, 31, 14, 24);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(kViewWidth, kViewHeight - self.centerDateButton.frame.origin.y - 50);
    
    //2.初始化collectionView
    self.collectionView  = [[UICollectionView alloc] initWithFrame:XXF_CGRectMake(0, 89, kViewWidth, kViewHeight - self.centerDateButton.frame.origin.y - 50) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = kWhiteColor;
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerNib:[UINib nibWithNibName:@"MonthDataView" bundle:nil] forCellWithReuseIdentifier:@"monthCell"];
    self.collectionView.contentOffset = CGPointMake(9 * kViewWidth, 0);
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MonthDataView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
    cell.backgroundColor = kClearColor;
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

#pragma mark - Action
- (void)beforeDay:(UIButton *)sender
{
    
}

- (void)afterDay:(UIButton *)sender
{
    
}

- (void)showTheCalender:(UIButton *)sender
{
    
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
        [button setTitle:@"2016-12-12" forState:UIControlStateNormal];
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showTheCalender:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _centerDateButton = button;
    }
    
    return _centerDateButton;
}

- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    
    return _myFmdbTool;
}

@end
