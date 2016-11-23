//
//  MonthContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MonthContentView.h"
#import "MonthDataView.h"

@interface MonthContentView () < UIScrollViewDelegate >

@property (nonatomic ,weak) UIButton *leftButton;
@property (nonatomic ,weak) UIButton *centerDateButton;
@property (nonatomic ,strong) UIImageView *calendarImageView;
@property (nonatomic ,weak) UIButton *rightButton;
@property (nonatomic ,weak) UIScrollView *scrollView;
@property (nonatomic ,weak) MonthDataView *leftView;
@property (nonatomic ,weak) MonthDataView *centerView;
@property (nonatomic ,weak) MonthDataView *rightView;

@end

@implementation MonthContentView

- (void)layoutSubviews
{
    self.leftButton.frame = XXF_CGRectMake(25, 31, 14, 24);
    
    self.centerDateButton.frame = XXF_CGRectMake(kViewCenter.x - 60, self.leftButton.center.y - 15, 120, 30);
    
    self.calendarImageView = [[UIImageView alloc] initWithFrame:XXF_CGRectMake(self.centerDateButton.frame.origin.x + 130, self.centerDateButton.frame.origin.y , 34, 30)];
    
    self.calendarImageView.image = [UIImage imageNamed:@"Calendar"];
    [self addSubview:self.calendarImageView];
    self.rightButton.frame = XXF_CGRectMake(kViewWidth - 32, 31, 14, 24);
    
    self.scrollView.frame = XXF_CGRectMake(0, 89, kViewWidth, kViewHeight - self.centerDateButton.frame.origin.y - 50);
    self.scrollView.contentSize = CGSizeMake(3 * kViewWidth, 0);
    
    self.leftView.frame = XXF_CGRectMake(0, 0, kViewWidth, self.scrollView.frame.size.height);
    self.centerView.frame = XXF_CGRectMake(kViewWidth, 0, kViewWidth, self.scrollView.frame.size.height);
    self.rightView.frame = XXF_CGRectMake(2 * kViewWidth, 0, kViewWidth, self.scrollView.frame.size.height);
}

#pragma mark - 懒加载
- (UIButton *)leftButton
{
    if (!_leftButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Left"] forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateNormal];
        
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
        
        [self addSubview:button];
        _centerDateButton = button;
    }
    
    return _centerDateButton;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.delegate = self;
        view.pagingEnabled = YES;
        view.bounces = NO;
        //        view.showsVerticalScrollIndicator = NO;
        
        [self addSubview:view];
        _scrollView = view;
    }
    
    return _scrollView;
}

- (MonthDataView *)leftView
{
    if (!_leftView) {
        MonthDataView *view = [[MonthDataView alloc] init];
        view.backgroundColor = kClearColor;
        
        [self.scrollView addSubview:view];
        _leftView = view;
    }
    
    return _leftView;
}

- (MonthDataView *)centerView
{
    if (!_centerView) {
        MonthDataView *view = [[MonthDataView alloc] init];
        view.backgroundColor = kClearColor;
        
        [self.scrollView addSubview:view];
        _centerView = view;
    }
    
    return _centerView;
}

- (MonthDataView *)rightView
{
    if (!_rightView) {
        MonthDataView *view = [[MonthDataView alloc] init];
        view.backgroundColor = kClearColor;
        
        [self.scrollView addSubview:view];
        _rightView = view;
    }
    
    return _rightView;
}

@end
