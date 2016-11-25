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
- (IBAction)loginAction:(UIButton *)sender
{
    OPMainViewController *vc = [[OPMainViewController alloc] init];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
}
- (IBAction)signupAction:(UIButton *)sender
{
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    vc.loginType = LoginTypeRegister;
    [self.navigationController pushViewController:vc animated:YES];
}
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

@end
