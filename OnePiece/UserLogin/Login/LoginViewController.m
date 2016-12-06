//
//  LoginViewController.m
//  OnePiece
//
//  Created by JustFei on 2016/11/23.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "LoginViewController.h"
#import "OPMainViewController.h"
#import "RegisterViewController.h"
#import "FMDBTool.h"
#import "MBProgressHUD.h"
#import "UserInfoModel.h"

@interface LoginViewController () < UITextFieldDelegate >
{
    NSInteger userLength;
    NSInteger pwdLength;
}
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdButton;
@property (nonatomic ,strong) FMDBTool *myFmdbTool;
@property (nonatomic ,strong) MBProgressHUD *myHud;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.enabled = NO;
    userLength = 0;
    pwdLength = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = kClearColor;
    [[self.navigationController.navigationBar subviews].firstObject setAlpha:0];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController.navigationBar setTintColor:kBlackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 101) {
        if (string.length == 0) {
            userLength = textField.text.length - range.length;
        }else {
        userLength = textField.text.length + string.length;
        }
    }
    if (textField.tag == 102) {
        if (string.length == 0) {
            pwdLength = textField.text.length - range.length;
        }else {
            pwdLength = textField.text.length + string.length;
        }
    }
    
    if (userLength && pwdLength >= 8) {
        self.loginButton.enabled = YES;
    }else {
        self.loginButton.enabled = NO;
    }
    
    NSLog(@"%ld === %ld",(long)userLength , (long)pwdLength);
    
    return YES;
}

#pragma mark - Action
- (IBAction)showCountryNumberViewController:(UIButton *)sender
{
    
}
- (IBAction)showPwdNumber:(UIButton *)sender
{
    if (self.pwdTF.text.length != 0) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.pwdTF.secureTextEntry = NO;
        }else {
            self.pwdTF.secureTextEntry = YES;
        }
    }
}

//登陆按钮
- (IBAction)loginAction:(UIButton *)sender
{
    self.myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.myHud.mode = MBProgressHUDModeIndeterminate;
    [self.myHud.label setText:@"Loading..."];
    //都有数据的情况下，请求查询
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserModel"];
    [bquery whereKey:@"account" equalTo:self.userNameTF.text];
    
    [bquery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0) {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该用户不存在，请重新输入。" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [view show];
            [self.myHud hideAnimated:YES];
        }
    }];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        //隐藏等待菊花
        [self.myHud hideAnimated:YES];
        
        if (!error) {
            for (BmobObject *obj in array) {
                //打印playerName
                DLog(@"phone = %@", [obj objectForKey:@"account"]);
                DLog(@"pwd = %@", [obj objectForKey:@"pwd"]);
                //打印objectId,createdAt,updatedAt
                
                if (![self.pwdTF.text isEqualToString:[obj objectForKey:@"pwd"]]) {
                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不正确，请重新输入。" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
                    [view show];
                }else {
                    //当前用户名
                    [[NSUserDefaults standardUserDefaults] setObject:self.userNameTF.text forKey:@"account"];
                    
                    NSString *account = [obj objectForKey:@"account"];
                    NSString *userName = [obj objectForKey:@"userName"];
                    NSNumber *genderNum = [obj objectForKey:@"gender"];
                    NSString *birthday = [obj objectForKey:@"birthday"];
                    NSNumber *heightNum = [obj objectForKey:@"height"];
                    NSNumber *weightNum = [obj objectForKey:@"weight"];
                    NSNumber *stepLengthNum = [obj objectForKey:@"stepLength"];
                    NSNumber *stepTarghtNum = [obj objectForKey:@"stepTarget"];
                    NSNumber *sleepTarghtNum = [obj objectForKey:@"sleepTarget"];
                    NSString *PeripheralName = [obj objectForKey:@"peripheralName"];
                    NSString *PeripheralUUID = [obj objectForKey:@"peripheralUUID"];
                    UserInfoModel *model = [UserInfoModel userInfoModelWithAccount:account andUserName:userName andGender:genderNum.integerValue andBirthday:birthday andHeight:heightNum.integerValue andWeight:weightNum.integerValue andStepLength:stepLengthNum.integerValue andStepTarget:stepTarghtNum.integerValue andSleepTarget:sleepTarghtNum.integerValue andPeripheralName:PeripheralName andPeripheralUUID:PeripheralUUID];
                    
                    //存储服务器上的用户信息数据
                    [self.myFmdbTool insertUserInfoModel:model];
                    
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Login"];
                    OPMainViewController *vc = [[OPMainViewController alloc] init];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated: YES completion:nil];
                }
            }
        }else
        {
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，请重试" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
            [view show];
            DLog(@"%@",error);
        }
        
    }];
    
//    UserInfoModel *model = [UserInfoModel userInfoModelWithAccount:self.userNameTF.text andUserName:@"用户名" andGender:-1 andBirthday:@"2000/01/01" andHeight:180 andWeight:75 andStepLength:75 andStepTarget:8000 andSleepTarget:8 andPeripheralName:@"" andPeripheralUUID:@""];
//    NSArray *userArr = [self.myFmdbTool queryAllUserInfo];
//    if (userArr.count == 0) {
//        [self.myFmdbTool insertUserInfoModel:model];
//    }
//    [self.myHud hideAnimated:YES];
//    OPMainViewController *vc = [[OPMainViewController alloc] init];
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
}

//注册按钮
- (IBAction)signupAction:(UIButton *)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    vc.loginType = LoginTypeRegister;
    [self.navigationController pushViewController:vc animated:YES];
}

//重设密码按钮
- (IBAction)resetPwdAction:(UIButton *)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    vc.loginType = LoginTypeResetPwd;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 懒加载
- (FMDBTool *)myFmdbTool
{
    if (!_myFmdbTool) {
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
        _myFmdbTool = [[FMDBTool alloc] initWithPath:account];
    }
    
    return _myFmdbTool;
}

@end
