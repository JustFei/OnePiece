//
//  AboutViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutContentView.h"

@interface AboutViewController ()

@property (nonatomic ,weak) AboutContentView *contentView;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kBackGroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"用户信息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (AboutContentView *)contentView
{
    if (!_contentView) {
        AboutContentView *view = [[AboutContentView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
