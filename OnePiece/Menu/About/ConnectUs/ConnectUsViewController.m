//
//  ConnectUsViewController.m
//  OnePiece
//
//  Created by Faith on 2017/2/8.
//  Copyright © 2017年 manridy. All rights reserved.
//

#import "ConnectUsViewController.h"
#import <MessageUI/MessageUI.h>

@interface ConnectUsViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation ConnectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"联系我们";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connect"]];
    view.frame = self.view.bounds;
    
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setBackgroundColor:kRGBA(255, 255, 255, 0)];
    [button addTarget:self action:@selector(sendEmailToJiMan) forControlEvents:UIControlEventTouchUpInside];
    button.frame = XXF_CGRectMake(kControllerCenter.x - 125, 315 * kControllerWidth / 375, 250, 50);
    
    [self.view addSubview:button];
}

- (void)sendEmailToJiMan
{
    //邮件控制器
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    //邮件主题
    [picker setSubject:@"用户反馈"];
    
    //收件人
    NSArray *toRecipients = [NSArray arrayWithObject:@"Ji.Man@outlook.com"];
    [picker setToRecipients:toRecipients];
    
    if (picker) {
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }else {
        //复制邮件地址到剪切板
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"Ji.Man@outlook.com";
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"已经为您复制邮箱地址至剪切板，请前往发送邮件";
        [hud hideAnimated:YES afterDelay:1.5];
        
//        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经为您复制邮箱地址至剪切板，请前往发送邮件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [view show];
    }
    
    //[[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"Ji.Man@outlook.com"]];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
