//
//  MenuViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/15.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuContentView.h"

@interface MenuViewController ()

@property (nonatomic ,weak) MenuContentView *contentView;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kUIColorFromHEX(0xfabe00, 1);
    
    self.view.backgroundColor = kUIColorFromHEX(0xf2f2f2, 1);
    
    self.contentView.backgroundColor = kUIColorFromHEX(0xf2f2f2, 1);
}

#pragma mark - 懒加载
- (MenuContentView *)contentView
{
    if (!_contentView) {
        MenuContentView *view = [[MenuContentView alloc] initWithFrame:XXF_CGRectMake(0, 64, kControllerWidth, kControllerHeight)];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end