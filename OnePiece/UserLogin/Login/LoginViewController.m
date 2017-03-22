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
#import "NetworkTool.h"

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
            if (userLength > 11) {
                userLength = 11;
                return NO;
            }
        }
    }
    if (textField.tag == 102) {
        if (string.length == 0) {
            pwdLength = textField.text.length - range.length;
        }else {
            pwdLength = textField.text.length + string.length;
            if (pwdLength > 16) {
                pwdLength = 16;
                return NO;
            }
        }
    }
    
    if (userLength == 11 && pwdLength >= 6 && pwdLength <= 16) {
        self.loginButton.enabled = YES;
    }else {
        self.loginButton.enabled = NO;
    }
    
    DLog(@"%ld === %ld",(long)userLength , (long)pwdLength);
    
    //当重新编辑密文密码时，可以做到拼接的功能
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.pwdTF && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    
    return YES;
}

//点击clear按钮后，置登陆按钮为NO
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.loginButton.enabled = NO;
    if (textField.tag == 101) {
        userLength = 0;
    }else if (textField.tag == 102) {
        pwdLength = 0;
    }
    return YES;
}

#pragma mark - Action
- (IBAction)showCountryNumberViewController:(UIButton *)sender
{
    
}
- (IBAction)showPwdNumber:(UIButton *)sender
{
    sender.selected = !sender.selected;
    //    if (self.pwdTF.text.length != 0) {
    if (sender.selected) {
        self.pwdTF.secureTextEntry = NO;
        self.pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    }else {
        self.pwdTF.secureTextEntry = YES;
        self.pwdTF.keyboardType = UIKeyboardTypeASCIICapable;
    }
    //    }
}

//登陆按钮
- (IBAction)loginAction:(UIButton *)sender
{
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        self.myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.myHud.mode = MBProgressHUDModeIndeterminate;
        [self.myHud.label setText:@"Loading..."];
        //都有数据的情况下，请求查询
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"UserModel"];
        [bquery whereKey:@"account" equalTo:self.userNameTF.text];
        
        [bquery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (number == 0) {
                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不正确，请重新输入" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
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
                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不正确，请重新输入" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
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
                        NSString *bindPeripheralUUID = [obj objectForKey:@"bindPeripheralUUID"];
                        NSString *isBind = [obj objectForKey:@"isBind"];
                        NSString *PeripheralMac = [obj objectForKey:@"peripheralMac"];
                        NSDate *registTimeDate = obj.createdAt;
                        NSNumber *moneyNum = [obj objectForKey:@"money"];
                        BmobFile *userIconFile = [obj objectForKey:@"userIcon"];
                        //这里需要同步请求头像图片的处理
                        UIImage *userIcon = [self getImageFromURL:userIconFile.url];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
                        NSString *registTime = [formatter stringFromDate:registTimeDate];
                        
                        UserInfoModel *model = [UserInfoModel userInfoModelWithAccount:account andUserName:userName andGender:genderNum.integerValue andBirthday:birthday andHeight:heightNum.integerValue andWeight:weightNum.integerValue andStepLength:stepLengthNum.integerValue andStepTarget:stepTarghtNum.integerValue andSleepTarget:sleepTarghtNum.integerValue andPeripheralName:PeripheralName andbindPeripheralUUID:bindPeripheralUUID andPeripheralMac:PeripheralMac andRegistTime:registTime];
                        model.money = [NSString stringWithFormat:@"%@",moneyNum];
                        
                        //存储服务器上的用户信息数据
                        [self.myFmdbTool insertUserInfoModel:model];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:PeripheralName forKey:@"bindPeripheralName"];
                        [[NSUserDefaults standardUserDefaults] setObject:bindPeripheralUUID forKey:@"bindPeripheralUUID"];
                        [[NSUserDefaults standardUserDefaults] setObject:PeripheralMac forKey:@"peripheralMac"];
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Login"];
                        NSData *imageData = UIImagePNGRepresentation(userIcon);
                        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userHeadImage"];
                        [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
                        if ([isBind isEqualToString:@"0"]) {
                            [[NSUserDefaults standardUserDefaults] setBool:0 forKey:@"isBind"];
                        }else if ([isBind isEqualToString:@"1"]) {
                            [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"isBind"];
                        }
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
    }
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
    if (![NetworkTool isExistenceNetwork]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"当前网络不可用，请检查网络连接";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        vc.loginType = LoginTypeResetPwd;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 下载图片
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    //异步连接（block）
    //    1.设置请求路径
    NSURL *url = [NSURL URLWithString:fileURL];
    
    //    2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    //NSMutableData *recieveData = [NSMutableData data];
    //    3.发送请求
    //同步数据请求
    NSData *recieveData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return [UIImage imageWithData:recieveData];
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
