//
//  OPMainViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "OPMainViewController.h"
#import "OPMainContentView.h"

@interface OPMainViewController ()

@property (nonatomic ,weak) OPMainContentView *contentView;

@end

@implementation OPMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 21, 21);
    [leftButton setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pushMenuList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 21, 21);
    [rightButton setImage:[UIImage imageNamed:@"History"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(pushHistoryView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
}

#pragma makr - Action
- (void)pushMenuList
{
    
}

- (void)pushHistoryView
{
    
}

#pragma mark - 懒加载
- (OPMainContentView *)contentView
{
    if (!_contentView) {
        OPMainContentView *view = [[OPMainContentView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
