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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"用户信息";
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = XXF_CGRectMake(5, 11.6667, 13, 18);
    [leftButton setTitle:@"haha" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(makeSureBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.contentView.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
    [self.contentView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
//未保存的情况下返回提示
- (void)makeSureBack
{
    if (self.contentView.isChange) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改信息尚未保存，确认返回" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancleAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:okAc];[vc addAction:cancleAc];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
