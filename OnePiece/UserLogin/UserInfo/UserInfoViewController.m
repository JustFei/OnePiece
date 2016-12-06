//
//  UserInfoViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoContentView.h"

@interface UserInfoViewController ()

@property (nonatomic ,weak) UserInfoContentView *contentView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"用户信息";
    self.view.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
    self.contentView.userModel = self.userModel;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UserInfoContentView *)contentView
{
    if (!_contentView) {
        UserInfoContentView *view = [[UserInfoContentView alloc] initWithFrame:XXF_CGRectMake(0, 64, kControllerWidth, kControllerHeight - 64)];
        
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
