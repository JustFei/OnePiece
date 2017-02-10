//
//  ChangeUserContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ChangeUserContentView.h"
#import "ChangeUserTableViewCell.h"

@interface ChangeUserContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) NSArray *textLabelArr;
@property (nonatomic ,weak) UIButton *changeButton;

@end

@implementation ChangeUserContentView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.textLabelArr = @[@[@"用户密码"],@[@"中国",@"手机号码",@"验证码"]];
    }
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 0, kViewWidth, 242);
    self.changeButton.frame = XXF_CGRectMake(kViewCenter.x - 50, self.tableView.frame.origin.y + 342 , 100, 40);
}

#pragma mark - Action
- (void)changeUserAction:(UIButton *)sender
{
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.textLabelArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changeUserCell"];
    
    NSArray *arr = self.textLabelArr[indexPath.section];
    cell.getSecurityCodeButton.hidden = YES;
    cell.phoneNumberTextField.hidden = YES;
    cell.countryNumberLabel.hidden = YES;
    cell.eyeButton.hidden = YES;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.section) {
        case 0:
        {
            cell.infoTextField.placeholder = arr[indexPath.row];
            cell.eyeButton.hidden = NO;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
                    cell.infoTextField.placeholder = arr[indexPath.row];
                    cell.infoTextField.enabled = NO;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 1:
                {
                    cell.countryNumberLabel.hidden = NO;
                    cell.phoneNumberTextField.hidden = NO;
                    cell.infoTextField.hidden = YES;
                    cell.phoneNumberTextField.placeholder = arr[indexPath.row];
                }
                    break;
                case 2:
                {
                    cell.infoTextField.placeholder = arr[indexPath.row];
                    cell.getSecurityCodeButton.hidden = NO;
                }
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:XXF_CGRectMake(0, 0, kViewWidth, 20)];
    view.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else {
        return 20 * kViewWidth / 375;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        view.tableFooterView = [[UIView alloc] init];
        view.scrollEnabled = NO;
        
        [view registerNib:[UINib nibWithNibName:@"ChangeUserTableViewCell" bundle:nil] forCellReuseIdentifier:@"changeUserCell"];
        
        view.delegate = self;
        view.dataSource = self;
        
        [self addSubview:view];
        _tableView = view;
    }
    
    return _tableView;
}

- (UIButton *)changeButton
{
    if (!_changeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"更改" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button setTitleColor:kUIColorFromHEX(0x0076ff, 1) forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x00a0e9, 1) forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(changeUserAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _changeButton = button;
    }
    
    return _changeButton;
}

@end
