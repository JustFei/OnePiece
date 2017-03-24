//
//  ChangePwdContentView.m
//  OnePiece
//
//  Created by JustFei on 2016/11/16.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "ChangePwdContentView.h"
#import "ChangeUserTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

@interface ChangePwdContentView () < UITableViewDelegate , UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *changePwdButton;
@property (nonatomic ,strong) MBProgressHUD *myHud;
//@property (nonatomic ,strong) UITextField *n2PwdTextField;

@end

@implementation ChangePwdContentView

#pragma mark - lifeCycle
- (void)layoutSubviews
{
    self.tableView.frame = XXF_CGRectMake(0, 10, kViewWidth, 107);
    self.changePwdButton.frame = XXF_CGRectMake(kViewCenter.x - 50, 269 , 100, 40);
}

#pragma mark - Action
- (void)changePwdAction:(UIButton *)sender
{
    if ([NetworkTool isExistenceNetwork]) {
        if (self.oldPwdTextField.text.length > 0 && self.nPwdTextField.text.length > 0) {
            self.myHud = [MBProgressHUD showHUDAddedTo:[self findViewController:self].navigationController.view animated:YES];
            self.myHud.mode = MBProgressHUDModeIndeterminate;
            [self.myHud.label setText:@"Loading..."];
            //都有数据的情况下，请求查询
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserModel"];
            NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
            [bquery whereKey:@"account" equalTo:account];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    for (BmobObject *obj in array) {
                        NSString *pwd = [obj objectForKey:@"pwd"];
                        if (![pwd isEqualToString:self.oldPwdTextField.text]) {
                            //隐藏等待菊花
                            [self.myHud hideAnimated:YES];
                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧密码错误，请重新输入" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                            [view show];
                        }else {
                            int count = [self validatePassword];
                            if (count == 3 && self.nPwdTextField.text.length >= 6 && self.nPwdTextField.text.length <= 16) {
                                [obj setObject:self.nPwdTextField.text forKey:@"pwd"];
                                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    
                                    if (error) {
                                        self.myHud.mode = MBProgressHUDModeText;
                                        self.myHud.label.text = @"网络服务器不可用，请稍后再尝试";
                                        self.myHud.minSize = CGSizeMake(132.f, 108.0f);
                                        [self.myHud hideAnimated:YES afterDelay:1.5];
                                    }else {
                                        [self.myHud.label setText:@"密码修改成功"];
                                        [self.myHud hideAnimated:YES afterDelay:1.5];
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                            if (self.popViewController) {
                                                self.popViewController();
                                            }
                                        });
                                    }
                                }];
                            }else {
                                [self.myHud hideAnimated:YES];
                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查新密码长度6-16位，同时包含数字、大小写字母" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                                [view show];
                            }
                        }
                    }
                }
            }];
        }else {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
        }
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
//        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [view show];
    }
}

- (void)showThePwd:(UIButton *)sender
{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 100:
            [self.oldPwdTextField setSecureTextEntry:!self.oldPwdTextField.secureTextEntry];
            break;
        case 101:
            [self.nPwdTextField setSecureTextEntry:!self.nPwdTextField.secureTextEntry];
            break;
            
        default:
            break;
    }
}

- (int)validatePassword

{
    int count = 0;
    //    NSString * length = @"^\\w{6,18}$";//长度
    
    NSString * number = @"^\\w*\\d+\\w*$";//数字
    
    NSString * lower = @"^\\w*[a-z]+\\w*$";//小写字母
    
    NSString * upper = @"^\\w*[A-Z]+\\w*$";//大写字母
    
    //    NSString * punct = @"/([\u4E00-\u9FA5]|[\uFE30-\uFFA0])+/";//标点符号
    
    
    NSPredicate *regexnumber = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    NSPredicate *regexlower = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",lower];
    NSPredicate *regexupper = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",upper];
    //    NSPredicate *regexpunct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",punct];
    
    BOOL isHaveNumber = [regexnumber evaluateWithObject: self.nPwdTextField.text];
    BOOL isHaveLower = [regexlower evaluateWithObject:self.nPwdTextField.text];
    BOOL isHaveUpper = [regexupper evaluateWithObject:self.nPwdTextField.text];
    //    BOOL isHavePunct = [regexpunct evaluateWithObject:self.pwdTextField.text];
    
    //    return [self validateWithRegExp: number] && [self validateWithRegExp: lower] && [self validateWithRegExp: upper];
    
    if (isHaveNumber) {
        count ++;
    }
    if (isHaveLower) {
        count ++;
    }
    if (isHaveUpper) {
        count ++;
    }
    //    if (isHavePunct) {
    //        count ++;
    //    }
    
    return count;
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changePwdCell"];
    cell.countryNumberLabel.hidden = YES;
    cell.phoneNumberTextField.hidden = YES;
    cell.getSecurityCodeButton.hidden = YES;
    cell.eyeButton.tag = 100 + indexPath.row;
    [cell.eyeButton addTarget:self action:@selector(showThePwd:) forControlEvents:UIControlEventTouchUpInside];
    cell.infoTextField.secureTextEntry = YES;
    cell.infoTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.infoTextField.placeholder = @"输入旧的账号密码";
            self.oldPwdTextField = cell.infoTextField;
        }
            break;
        case 1:
        {
            cell.infoTextField.placeholder = @"新密码（6-16位，数字、大小写字母）";
            CGRect oldRect = cell.infoTextField.frame;
            oldRect.size.width = 400;
            cell.infoTextField.frame = oldRect;
            self.nPwdTextField = cell.infoTextField;
        }
            break;
        //case 2:
        //{
        //    cell.infoTextField.placeholder = @"确认新的密码";
        //    self.n2PwdTextField = cell.infoTextField;
        //}
        //    break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length + string.length > 16) {
        
        return NO;
    }
    //当重新编辑密文密码时，可以做到拼接的功能
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.oldPwdTextField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    if (textField == self.nPwdTextField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
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
        [button setTitle:@"重置" forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x0076ff, 1) forState:UIControlStateNormal];
        [button setTitleColor:kUIColorFromHEX(0x00a0e9, 1) forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(changePwdAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        _changePwdButton = button;
    }
    
    return _changePwdButton;
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
