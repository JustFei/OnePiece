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
    self.view.backgroundColor = kBackGroundColor;
    self.contentView.backgroundColor = kBackGroundColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"]) {
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userHeadImage"];
        [self.contentView.headImageView setImage:[UIImage imageWithData:imageData]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        self.contentView.nameLabel.text = userName;
    }
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
