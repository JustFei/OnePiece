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
    self.navigationItem.title = @"重置密码";
    
    self.contentView.popViewController = ^() {
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    //backButton
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = XXF_CGRectMake(5, 11.6667, 100, 18);
    [leftButton setTitle:@"用户信息" forState:UIControlStateNormal];
    [leftButton setTitleColor:kBlackColor forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    leftButton.imageView.frame = XXF_CGRectMake(0, 0, 10, 13);
    [leftButton addTarget:self action:@selector(makeSureBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    //防止tableView自动下移
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
//未保存的情况下返回提示
- (void)makeSureBack
{
    if (self.contentView.oldPwdTextField.text.length > 0 || self.contentView.nPwdTextField.text.length > 0) {
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否放弃修改" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAc = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancleAc = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:okAc];[vc addAction:cancleAc];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentView.oldPwdTextField endEditing:YES];
    [self.contentView.nPwdTextField endEditing:YES];
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
