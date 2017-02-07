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

@interface ChangePwdContentView () < UITableViewDelegate , UITableViewDataSource >

@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *changePwdButton;
@property (nonatomic ,strong) MBProgressHUD *myHud;
@property (nonatomic ,strong) UITextField *oldPwdTextField;
@property (nonatomic ,strong) UITextField *nPwdTextField;   //newPwdTextField，不能如此命名，所以命名为nPwdTextField
@property (nonatomic ,strong) UITextField *n2PwdTextField;

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
    if ([NetworkTool isExistenceNetwork]) {
        self.myHud = [MBProgressHUD showHUDAddedTo:self animated:YES];
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
                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"旧的密码输入有误，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [view show];
                    }else {
                        int count = [self validatePassword];
                        if (count == 3 && self.nPwdTextField.text.length >= 6 && self.nPwdTextField.text.length <= 16) {
                            if ([self.nPwdTextField.text isEqualToString:self.n2PwdTextField.text]) {
                                    [obj setObject:self.nPwdTextField.text forKey:@"pwd"];
                                    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        
                                        if (error) {
                                            [self.myHud hideAnimated:YES];
                                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接异常，密码更改失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                            [view show];
                                        }else {
                                            [self.myHud.label setText:@"密码更改成功"];
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
                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入密码不一致，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                [view show];
                            }
                        }else {
                            [self.myHud hideAnimated:YES];
                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度在6-16位的，包含数字、大小字母的密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [view show];
                        }
                        
                    }
                }
            }
        }];
    }else {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
    }
    
}

- (void)showThePwd:(UIGestureRecognizer *)sender
{
    switch ([sender view].tag) {
        case 100:
            [self.oldPwdTextField setSecureTextEntry:!self.oldPwdTextField.secureTextEntry];
            break;
        case 101:
            [self.nPwdTextField setSecureTextEntry:!self.nPwdTextField.secureTextEntry];
            break;
        case 102:
            [self.n2PwdTextField setSecureTextEntry:!self.n2PwdTextField.secureTextEntry];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"changePwdCell"];
    cell.countryNumberLabel.hidden = YES;
    cell.phoneNumberTextField.hidden = YES;
    cell.getSecurityCodeButton.hidden = YES;
    cell.eyeImageView.tag = 100 + indexPath.row;
    cell.eyeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showThePwd:)];
    [cell.eyeImageView addGestureRecognizer:tap];
    cell.infoTextField.secureTextEntry = YES;
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
            cell.infoTextField.placeholder = @"输入新的密码";
            self.nPwdTextField = cell.infoTextField;
        }
            break;
        case 2:
        {
            cell.infoTextField.placeholder = @"确认新的密码";
            self.n2PwdTextField = cell.infoTextField;
        }
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
