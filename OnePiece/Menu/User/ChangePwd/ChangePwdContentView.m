//
//  ChangePwdContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ChangePwdContentView.h"
#import "ChangeUserTableViewCell.h"

@interface ChangePwdContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *changePwdButton;

@end

@implementation ChangePwdContentView

#pragma mark - lifeCycle
- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 10, kViewWidth, 159);
    self.changePwdButton.frame = XXF_CGRectMake(kViewCenter.x - 50, 269 , 100, 40);
}

#pragma mark - Action
- (void)changePwdAction:(UIButton *)sender
{
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changePwdCell"];
    cell.countryNumberLabel.hidden = YES;
    cell.phoneNumberTextField.hidden = YES;
    cell.getSecurityCodeButton.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.infoTextField.placeholder = @"输入旧的账号密码";
            break;
        case 1:
            cell.infoTextField.placeholder = @"输入新的密码";
            break;
        case 2:
            cell.infoTextField.placeholder = @"确认新的密码";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.scrollEnabled = NO;
        
        view.delegate = self;
        view.dataSource = self;
        
        view.tableFooterView = [[UIView alloc] init];
        [view registerNib:[UINib nibWithNibName:@"ChangeUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"changePwdCell"];
        
        [self addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (UIButton *)changePwdButton
{
    if (!_changePwdButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更改" forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x0076ff, 1) forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x00a0e9, 1) forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(changePwdAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _changePwdButton = button;
    }
    
    return _changePwdButton;
}

@end
