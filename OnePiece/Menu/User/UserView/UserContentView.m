//
//  UserContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "UserContentView.h"
#import "UserTableViewCell.h"
#import "ChangeUserViewController.h"
#import "ChangePwdViewController.h"

@interface UserContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,strong) NSArray *titleArr;
@property (nonatomic ,strong) NSMutableArray *infoArr;
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,strong) UILabel *nickName;

@end

@implementation UserContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.titleArr = @[@[@"更改账号",@"更改密码",@"二维码"],@[@"头像",@"昵称"],@[@"性别",@"生日",@"身高",@"体重"],@[@"目标步数"]];
        NSArray *arr = @[@[@"+86 18812341234",@"********",@""],@[@"",@"+86 18812341234"],@[@"未选择",@"1980/01/01",@"150cm",@"80kg"],@[@"10000"]];
        self.infoArr = [NSMutableArray arrayWithArray:arr];
    }
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 0, kViewWidth, kViewHeight);
}

- (void)showNameAlert
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"用户昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [vc addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入昵称";
        textField.borderStyle = UITextBorderStyleNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *nickTextField = vc.textFields.firstObject;
        self.nickName.text = nickTextField.text;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    okAction.enabled = NO;
    [vc addAction:cancleAction];
    [vc addAction:okAction];
    
    [[self findViewController:self] presentViewController:vc animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)[self findViewController:self].presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 0;
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = self.titleArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    
    NSArray *titleArray = self.titleArr[indexPath.section];
    NSArray *infoArray = self.infoArr[indexPath.section];
    
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.titleLabel.textColor = kUIColorFromHEX(0x333333, 1);
    
    cell.infoLabel.text = infoArray[indexPath.row];
    cell.infoLabel.textColor = kUIColorFromHEX(0xcccccc, 1);
    
    cell.QRCodeImageView.hidden = YES;
    cell.headImageView.hidden = YES;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 2) {
                cell.QRCodeImageView.hidden = NO;
                cell.QRCodeImageView.image = [UIImage imageNamed:@"QRCodeImage_default"];
                //show QRCodeImage here
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.headImageView.hidden = NO;
                cell.headImageView.image = [UIImage imageNamed:@"HeadImage_default"];
                //show the headImage here
            }
            if (indexPath.row == 1) {
                self.nickName = cell.infoLabel;
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
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    ChangeUserViewController *vc = [[ChangeUserViewController alloc] init];
                    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:
                {
                    ChangePwdViewController *vc = [[ChangePwdViewController alloc] init];
                    [[self findViewController:self].navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 2:
                {
                    //show QRCode View
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    //show headImageView
                }
                    break;
                case 1:
                {
                    [self showNameAlert];
                }
                    break;
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
if (!_tableView) {
UITableView *view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    view.backgroundColor = kUIColorFromHEX(0xf3f3f3, 1);
    view.tableFooterView = [[UIView alloc] init];
    
    view.delegate = self;
    view.dataSource = self;
    [view registerNib:[UINib nibWithNibName:@"UserTableViewCell" bundle:nil] forCellReuseIdentifier:@"userCell"];
    
    [self addSubview:view];
    _tableView = view;
}
    
    return _tableView;
}

#pragma mark - 获取当前View的控制器的方法
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
