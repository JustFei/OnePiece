//
//  UserViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "UserViewController.h"
#import "UserContentView.h"

@interface UserViewController () 

@property (nonatomic ,weak) UserContentView *contentView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"用户信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UserContentView *)contentView
{
    if (!_contentView) {
        UserContentView *view = [[UserContentView alloc] initWithFrame:XXF_CGRectMake(0, 64, kControllerWidth, kControllerHeight - 64)];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
