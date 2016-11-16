//
//  ChangeUserViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ChangeUserViewController.h"
#import "ChangeUserContentView.h"

@interface ChangeUserViewController ()

@property (nonatomic ,weak) ChangeUserContentView *contentView;

@end

@implementation ChangeUserViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"更改账号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (ChangeUserContentView *)contentView
{
    if (!_contentView) {
        ChangeUserContentView *view = [[ChangeUserContentView alloc] initWithFrame:XXF_CGRectMake(0, 64, kControllerWidth, kControllerHeight - 64)];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
