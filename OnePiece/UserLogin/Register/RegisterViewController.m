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
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD.h"

@interface RegisterViewController () < UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate >
{
    int seconds;
    NSTimer *countDown;
    NSInteger pwdLength;
}
@property (nonatomic ,weak) UITableView *tableView;
@property (nonatomic ,weak) UIButton *signupButton;
@property (nonatomic ,weak) UITextField *phoneNumberTextField;
@property (nonatomic ,weak) UITextField *safeCodeTextField;
@property (nonatomic ,weak) UITextField *pwdTextField;
@property (nonatomic ,weak) UIButton *getSafeCodeButton;
@property (nonatomic ,strong) MBProgressHUD *hud;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    seconds = 60;
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
//        暂时不加入条款
//        self.navigationItem.rightBarButtonItem = rightItem;
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

- (void)geiVerificationCodeAction:(UIButton *)sender
{
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        if ([self isMobileNumber:self.phoneNumberTextField.text]) {
            //显示等待菊花
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            //验证次号码是否已经存在
            //查找UserModel表
            BmobQuery   *bquery = [BmobQuery queryWithClassName:@"UserModel"];
            //添加playerName不是小明的约束条件
            [bquery whereKey:@"account" equalTo:self.phoneNumberTextField.text];
            [bquery countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
                DLog(@"%d",number);
                switch (self.loginType) {
                    case LoginTypeRegister:
                    {
                        //如果存在，提示换号码
                        if (number > 0) {
                            //隐藏等待菊花
                            [self.hud hideAnimated:YES afterDelay:1];
                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该号码已被注册，请换个号码试试" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                            [view show];
                        }else {
                            //不存在，就请求验证码
                            //改变获取验证码按钮为60秒倒计时
                            [self changeGetSafeCodeButtonState];
                            //请求验证码
                            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumberTextField.text andTemplate:@"注册" resultBlock:^(int number, NSError *error) {
                                //隐藏等待菊花
                                [self.hud hideAnimated:YES afterDelay:1];
                                if (error) {
                                    //TODO:是否根据提示信息第4条来做提示
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码发送失败,请检查手机号和网络状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [view show];
                                } else {
                                    //获得smsID
                                    DLog(@"sms ID：%d",number);
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送，请注意查收" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                    [view show];
                                }
                            }];
                        }
                    }
                        break;
                    case LoginTypeResetPwd:
                    {
                        //存在，就请求验证码
                        if (number == 0) {
                            //隐藏等待菊花
                            [self.hud hideAnimated:YES afterDelay:1];
                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机尚未注册，请重新输入手机号" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                            [view show];
                        }else {
                            //改变获取验证码按钮为60秒倒计时
                            [self changeGetSafeCodeButtonState];
                            //请求验证码
                            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNumberTextField.text andTemplate:@"注册" resultBlock:^(int number, NSError *error) {
                                //隐藏等待菊花
                                [self.hud hideAnimated:YES afterDelay:1];
                                if (error) {
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码发送失败,请检查手机号和网络状态" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                    [view show];
                                    
                                    //隐藏等待菊花
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                } else {
                                    //获得smsID
                                    DLog(@"sms ID：%d",number);
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已发送，请注意查收" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                    [view show];
                                }
                            }];
                        }
                    }
                        
                    default:
                        break;
                }
            }];
        }else {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [view show];
        }
    }
}

- (void)signupAction:(UIButton *)sender
{
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        if ([self isMobileNumber:self.phoneNumberTextField.text]) {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [view show];
            
            return;
        }
        
        if (self.safeCodeTextField.text.length && self.pwdTextField.text.length) {
            if ([self validatePassword] == 3) {
                //显示等待菊花
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                //验证
                DLog(@"phone == %@,safeCode == %@",self.phoneNumberTextField.text ,self.safeCodeTextField.text);
                [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneNumberTextField.text andSMSCode:self.safeCodeTextField.text resultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        DLog(@"%@",@"验证成功，可执行用户请求的操作");
                        //验证码验证成功后，停止定时器
                        [self releaseTImer];
                        
                        //传递model给下一个控制器
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        model.account = self.phoneNumberTextField.text;
                        model.pwd = self.pwdTextField.text;
                        if (self.loginType == LoginTypeRegister) {
                            //注册 跳转到用户信息录入
                            //隐藏等待菊花
                            [self.hud hideAnimated:YES afterDelay:1];
                            UserInfoViewController *vc = [[UserInfoViewController alloc] init];
                            vc.userModel = model;
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController pushViewController:vc  animated:YES];
                            });
                        }else {
                            [self resetPwd];
                            //重设密码 跳转到登陆界面
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popViewControllerAnimated:YES];
                            });
                        }
                    } else {
                        DLog(@"%@",error);
                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码与手机号不匹配，请重新输入" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                        [view show];
                        //隐藏等待菊花
                        [self.hud hideAnimated:YES afterDelay:1];
                    }
                }];
            }else {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入长度在6-16位的，同时包含数字、大小字母的密码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                [view show];
            }
        }else {
            //显示等待菊花
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.label.text = @"请完整填写信息";
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hideAnimated:YES afterDelay:2];
        }
    }
}

- (void)resetPwd
{
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserModel"];
        //查找UserModel表里面account的数据
        NSString *account = self.phoneNumberTextField.text;
        [bquery whereKey:@"account" equalTo:account];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            //没有返回错误
            if (!error) {
                //对象存在
                if (array) {
                    for (BmobObject *obj in array) {
                        [obj setObject:self.pwdTextField.text forKey:@"pwd"];
                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (!error) {
                                self.hud.label.text = @"重设密码成功";
                                self.hud.mode = MBProgressHUDModeText;
                                [self.hud hideAnimated:YES afterDelay:1];
                            }else{
                                //进行错误处理
                                self.hud.label.text = @"网络服务器不可用，请稍后再尝试";
                                self.hud.mode = MBProgressHUDModeText;
                                [self.hud hideAnimated:YES afterDelay:2];
                            }
                        }];
                    }
                }
            }else{
                //进行错误处理
                self.hud.label.text = @"网络服务器不可用，请稍后再尝试";
                self.hud.mode = MBProgressHUDModeText;
                [self.hud hideAnimated:YES afterDelay:2];
            }
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)changeGetSafeCodeButtonState
{
    self.getSafeCodeButton.enabled = NO;
    self.getSafeCodeButton.backgroundColor = kGrayColor;
    
    countDown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [self.getSafeCodeButton setTitle:@"获取验证码" forState: UIControlStateNormal];
//        [self.getSafeCodeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.getSafeCodeButton.backgroundColor = kButtonGreenColor;
        [self.getSafeCodeButton setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"%d秒后尝试",seconds];
//        [self.getSafeCodeButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        self.getSafeCodeButton.backgroundColor = kGrayColor;
        [self.getSafeCodeButton setEnabled:NO];
        [self.getSafeCodeButton setTitle:title forState:UIControlStateNormal];
    }
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (countDown) {
        if ([countDown respondsToSelector:@selector(isValid)]) {
            if ([countDown isValid]) {
                [countDown invalidate];
                seconds = 60;
            }
        }
    }
}

//显示密码明文
- (void)showPwd:(UIButton *)sender
{
//    if (self.pwdTextField.text.length != 0) {
        sender.selected = !sender.selected;
        self.pwdTextField.secureTextEntry = !self.pwdTextField.secureTextEntry;
//    }
}

#pragma mark - TextFieldTool
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
    
    BOOL isHaveNumber = [regexnumber evaluateWithObject: self.pwdTextField.text];
    BOOL isHaveLower = [regexlower evaluateWithObject:self.pwdTextField.text];
    BOOL isHaveUpper = [regexupper evaluateWithObject:self.pwdTextField.text];
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

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 100) {                             //手机号输入框
        if (textField.text.length + string.length > 11) {
            return NO;
        }
    }else if (textField.tag == 101) {                       //验证码输入框
        if (textField.text.length + string.length > 6) {
            return NO;
        }
    }else if (textField.tag == 102) {                       //密码输入框
        
        
        if (string.length == 0) {
            pwdLength = textField.text.length - range.length;
        }else {
            pwdLength = textField.text.length + string.length;
            if (pwdLength > 16) {
                return NO;
            }
        }
        
        //当重新编辑密文密码时，可以做到拼接的功能
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField.isSecureTextEntry) {
            textField.text = toBeString;
            return NO;
        }
    }
    
    return YES;
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
    cell.eyeButton.hidden = YES;
    switch (indexPath.row) {
        case 0:
        {
            cell.countryNumberLabel.hidden = NO;
            cell.countryNumberLabel.text = @"中国";
            [cell.countryNumberLabel setTextColor:kUIColorFromHEX(0xcccccc, 1)];
            //暂时不能点击，所以隐藏掉箭头
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.countryNumberLabel.hidden = NO;
            cell.phoneNumberTF.hidden = NO;
            cell.phoneNumberTF.tag = 100;
            cell.phoneNumberTF.delegate = self;
            cell.countryNumberLabel.text = @"+86";
            self.phoneNumberTextField = cell.phoneNumberTF;
        }
            break;
        case 2:
        {
            cell.PwdNumberTF.hidden = NO;
            cell.getVerificationCodeButton.hidden = NO;
            cell.PwdNumberTF.placeholder = @"验证码";
            cell.PwdNumberTF.tag = 101;
            cell.PwdNumberTF.delegate = self;
            cell.PwdNumberTF.keyboardType = UIKeyboardTypeNumberPad;
            [cell.getVerificationCodeButton addTarget:self action:@selector(geiVerificationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            self.getSafeCodeButton = cell.getVerificationCodeButton;
            self.safeCodeTextField = cell.PwdNumberTF;
        }
            break;
        case 3:
        {
            cell.PwdNumberTF.hidden = NO;
            cell.PwdNumberTF.placeholder = @"密码（6-16位，同时包含数字、大小写字母）";
            self.pwdTextField = cell.PwdNumberTF;
            cell.PwdNumberTF.tag = 102;
            cell.PwdNumberTF.delegate = self;
            cell.PwdNumberTF.keyboardType = UIKeyboardTypeASCIICapable;
            cell.PwdNumberTF.secureTextEntry = YES;
            cell.eyeButton.hidden = NO;
            [cell.eyeButton addTarget:self action:@selector(showPwd:) forControlEvents:UIControlEventTouchUpInside];
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
        [button setTitleColor:kGrayColor forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [button addTarget:self action:@selector(signupAction:) forControlEvents:UIControlEventTouchUpInside];
//        button.enabled = NO;
        
        [self.view addSubview:button];
        _signupButton = button;
    }
    
    return _signupButton;
}

- (MBProgressHUD *)hud
{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
    }
    
    return _hud;
}

@end
