//
//  DayContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "DayContentView.h"
#import "DayDataView.h"


@interface DayContentView () < UICollectionViewDataSource ,UICollectionViewDelegate , UIPickerViewDataSource , UIPickerViewDelegate >
{
    NSInteger _rowCount;
}
@property (nonatomic ,weak) UIButton *leftButton;
@property (nonatomic ,weak) UIButton *centerDateButton;
@property (nonatomic ,strong) UIImageView *calendarImageView;
@property (nonatomic ,weak) UIButton *rightButton;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,copy) NSString *currentDateString;
@property (nonatomic ,assign) BOOL didEndDecelerating;
@property (nonatomic ,strong) UIPickerView *infoPickerView;

@end

@implementation DayContentView

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
    DLog(@"day == %f",kViewCenter.x);
    self.centerDateButton.frame = XXF_CGRectMake(kViewCenter.x - 60, self.leftButton.center.y - 15, 120, 30);
    
    self.calendarImageView = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(self.centerDateButton.frame.origin.x + 130, self.centerDateButton.center.y - 6.5 , 15, 13)];
    
    self.calendarImageView.image = [UIImage imageNamed:@"Calendar"];
    [self addSubview:self.calendarImageView];
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"DayDataView" bundle:nil] forCellWithReuseIdentifier:@"dayCell"];
    self.collectionView.contentOffset = CGPointMake((self.dataArr.count - 1) * kViewWidth, 0);
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DayDataView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
    DayHistoryModel *model = self.dataArr[indexPath.row];
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
        [self.centerDateButton setTitle:self.dateArr[i] forState:UIControlStateNormal];
        if (i == self.dateArr.count - 1) {
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
        [self.centerDateButton setTitle:self.dateArr[i] forState:UIControlStateNormal];
    }
}

#pragma mark - UIPickerViewDelegate && UIPickerViewDataSource
// UIPickerViewDataSource中定义的方法，该方法的返回值决定改控件包含多少列

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少哥列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dateArr.count;
}

// UIPickerViewDelegate中定义的方法，该方法返回NSString将作为UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component

{
    return self.dateArr[row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _rowCount = row;
}


#pragma mark - Action
- (void)beforeDay:(UIButton *)sender
{
    CGFloat index = self.collectionView.contentOffset.x/kViewWidth;
    int i = roundf(index);
    if (i != 0) {
        [self.collectionView setContentOffset:CGPointMake((i - 1) * kViewWidth, 0) animated:YES];
        [self.centerDateButton setTitle:self.dateArr[i - 1] forState:UIControlStateNormal];
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
        [self.centerDateButton setTitle:self.dateArr[i + 1] forState:UIControlStateNormal];
        if (i == self.dateArr.count - 2) {
            sender.enabled = NO;
        }
        self.leftButton.enabled = YES;
    }
}

- (void)showTheDateListHaveData:(UIButton *)sender
{
    _rowCount = -1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_rowCount != -1) {
            [self.collectionView setContentOffset:CGPointMake(_rowCount * kViewWidth, 0) animated:YES];
            [self.centerDateButton setTitle:self.dateArr[_rowCount] forState:UIControlStateNormal];
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    self.infoPickerView = [[UIPickerView alloc] initWithFrame:XXF_CGRectMake(0, 0, alert.view.frame.size.width - 30, 216)];
    self.infoPickerView.dataSource = self;
    self.infoPickerView.delegate = self;
    self.infoPickerView.tag = 2000;
    [alert.view addSubview:self.infoPickerView];
    
    [[self findViewController:self] presentViewController:alert animated:YES completion:nil];
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
        [button setTitle:self.dateArr[self.dateArr.count - 1] forState:UIControlStateNormal];
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showTheDateListHaveData:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _centerDateButton = button;
    }
    
    return _centerDateButton;
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
