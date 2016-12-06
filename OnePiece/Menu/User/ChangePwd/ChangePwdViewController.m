//
//  ChangePwdViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ChangePwdContentView.h"

@interface ChangePwdViewController ()

@property (nonatomic ,weak) ChangePwdContentView *contentView;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kBackGroundColor;
    self.navigationItem.title = @"更改密码";
    
    self.contentView.popViewController = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (ChangePwdContentView *)contentView
{
    if (!_contentView) {
        ChangePwdContentView *view = [[ChangePwdContentView alloc] initWithFrame:XXF_CGRectMake(0, 64, kControllerWidth, kControllerHeight - 64)];
        
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
