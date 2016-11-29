//
//  SettingViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/21.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingContentView.h"

@interface SettingViewController ()

@property (nonatomic ,weak) SettingContentView *contentView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = kBackGroundColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.contentView.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (SettingContentView *)contentView
{
    if (!_contentView) {
        SettingContentView *view = [[SettingContentView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:view];
        _contentView = view;
    }
    
    return _contentView;
}

@end
