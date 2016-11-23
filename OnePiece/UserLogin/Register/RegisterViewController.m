//
//  RegisterViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"
#import "UserInfoViewController.h"

@interface RegisterViewController () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *signupButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:1];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    
    if (self.loginType == LoginTypeRegister) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = XXF_CGRectMake(10, 5, 100, 40);
        [rightButton setTitle:@"用户条款" forState:UIControlStateNormal];
        [rightButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(showUserProtrol:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.title = @"注册";
    }else {
        self.navigationItem.title = @"忘记密码";
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    self.view.backgroundColor = kBackGroundColor;
    self.tableView.backgroundColor = kWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.signupButton.backgroundColor = kClearColor;
}

#pragma mark - Action
- (void)showUserProtrol:(UIButton *)sender
{
    
}

- (void)signupAction:(UIButton *)sender
{
    if (self.loginType == LoginTypeRegister) {
        //注册 跳转到用户信息录入
        UserInfoViewController *vc = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:vc  animated:YES];
    }else {
        //重设密码 跳转到登陆界面
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.countryNumberLabel.hidden = NO;
            cell.countryNumberLabel.text = @"中国";
            [cell.countryNumberLabel setTextColor:kUIColorFromHEX(0xcccccc, 1)];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.countryNumberLabel.hidden = NO;
            cell.phoneNumberTF.hidden = NO;
            cell.countryNumberLabel.text = @"+86";
        }
            break;
        case 2:
        {
            cell.PwdNumberTF.hidden = NO;
            cell.getVerificationCodeButton.hidden = NO;
            cell.PwdNumberTF.placeholder = @"验证码";
        }
            break;
        case 3:
        {
            cell.PwdNumberTF.hidden = NO;
            cell.PwdNumberTF.placeholder = @"密码（6-16位，数字、大小写字母和特殊符号）";
        }
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53 * kControllerWidth / 375;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:XXF_CGRectMake(0, 74, kControllerWidth, 212 * kControllerWidth / 375) style:UITableViewStylePlain];
        view.allowsSelection = NO;
        view.scrollEnabled = NO;
        view.delegate = self;
        view.dataSource = self;
        [view registerNib:[UINib nibWithNibName:@"RegisterTableViewCell" bundle:nil] forCellReuseIdentifier:@"registerCell"];
        
        [self.view addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (UIButton *)signupButton
{
    if (!_signupButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = XXF_CGRectMake(kControllerCenter.x - 30, 407, 60, 30);
        if (self.loginType == LoginTypeRegister) {
            [button setTitle:@"注册" forState:UIControlStateNormal];
        }else {
            [button setTitle:@"重设" forState:UIControlStateNormal];
        }
        [button setTitleColor:kUIColorFromHEX(0x0076ff, 1) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [button addTarget:self action:@selector(signupAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        _signupButton = button;
    }
    
    return _signupButton;
}

@end
