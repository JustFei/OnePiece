//
//  HistoryViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/22.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "HistoryViewController.h"
#import "DayContentView.h"

@interface HistoryViewController ()

@property (nonatomic ,strong) UIButton *dayButton;
@property (nonatomic ,strong) UIButton *monthButton;

@property (nonatomic ,weak) DayContentView *dayContentView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatUI
{
    self.view.backgroundColor = kBackGroundColor;
    
    self.dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dayButton setImage:[UIImage imageNamed:@"DayButton"] forState:UIControlStateNormal];
    [self.dayButton setImage:[UIImage imageNamed:@"DaySelectButton"] forState:UIControlStateSelected];
    self.dayButton.frame = XXF_CGRectMake(0, 74, 110, 40);
    [self.dayButton addTarget:self action:@selector(dayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dayButton];
    self.dayButton.selected = YES;
    
    self.monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.monthButton setImage:[UIImage imageNamed:@"MonthButton"] forState:UIControlStateNormal];
    [self.monthButton setImage:[UIImage imageNamed:@"MonthSelectButton"] forState:UIControlStateSelected];
    self.monthButton.frame = XXF_CGRectMake(kControllerWidth - 110, 74, 110, 40);
    [self.monthButton addTarget:self action:@selector(monthAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.monthButton];
    
    self.dayContentView.backgroundColor = kClearColor;
}

#pragma mark - Action
- (void)dayAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)monthAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

#pragma mark - 懒加载
- (DayContentView *)dayContentView
{
    if (!_dayContentView) {
        DayContentView *view = [[DayContentView alloc] initWithFrame:XXF_CGRectMake(0, self.dayButton.frame.origin.y + self.dayButton.frame.size.height, kControllerWidth, kControllerHeight - self.dayButton.frame.origin.y - self.dayButton.frame.size.height)];
        
        [self.view addSubview:view];
        _dayContentView = view;
    }
    
    return _dayContentView;
}

@end
