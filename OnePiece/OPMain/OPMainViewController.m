//
//  OPMainViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "OPMainViewController.h"
#import "OPMainContentView.h"
#import "MenuViewController.h"

@interface OPMainViewController ()

@property (nonatomic ,strong) OPMainContentView *contentView;

@end

@implementation OPMainViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = kClearColor;
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    
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
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setTintColor:kBlackColor];
}

#pragma makr - Action
- (void)pushMenuList
{
    MenuViewController *vc = [[MenuViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushHistoryView
{
    
}

- (void)musicAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)cameraAction:(UIButton *)sender
{
    
}

- (void)syncAction:(UIButton *)sender
{
    
}

- (void)PKAction:(UIButton *)sender
{
    
}

#pragma mark - 懒加载
- (OPMainContentView *)contentView
{
    if (!_contentView) {
        _contentView = [[OPMainContentView alloc] initWithFrame:self.view.bounds];
        _contentView.backGroundImageView.backgroundColor = [UIColor whiteColor];
        [_contentView.musicButton addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.photoButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.syncButton addTarget:self action:@selector(syncAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView.PKButton addTarget:self action:@selector(PKAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_contentView];
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
