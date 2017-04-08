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
    //测试功能
    [button addTarget:self action:@selector(sendLogToEmail:) forControlEvents:UIControlEventTouchDown];
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

//测试功能，发送log和数据库到邮箱
- (void)sendLogToEmail:(UIButton *)sender
{
    // 创建邮件发送界面
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置收件人
    [mailCompose setToRecipients:@[@"1107965402@qq.com"]];
    // 设置邮件主题
    [mailCompose setSubject:@"ACGFit_Log"];
    //添加 log 附件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSArray *logArr = [self getFilenamelistOfType:@"log" fromDirPath:logDirectory];
    for (NSString *logName in logArr) {
        NSData *log = [NSData dataWithContentsOfFile:[logDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@", logName]]];
        [mailCompose addAttachmentData:log mimeType:@"log" fileName:logName];
    }
    
    //添加数据库附件
    NSArray *dbArr = [self getFilenamelistOfType:@"sqlite" fromDirPath:[paths objectAtIndex:0]];
    for (NSString *dbName in dbArr) {
        NSData *db = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingString:[NSString stringWithFormat:@"/%@", dbName]]];
        [mailCompose addAttachmentData:db mimeType:@"sqlite" fileName:dbName];
    }

    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate的代理方法：
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//遍历 Documents 目录下的所有 type 文件
- (NSArray *)getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath
{
    NSMutableArray *filenamelist = [NSMutableArray arrayWithCapacity:10];
    NSArray *tmplist = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    
    for (NSString *filename in tmplist) {
        NSString *fullpath = [dirPath stringByAppendingPathComponent:filename];
        if ([self isFileExistAtPath:fullpath]) {
            if ([[filename pathExtension] isEqualToString:type]) {
                [filenamelist  addObject:filename];
            }
        }
    }
    
    return filenamelist;
}

- (BOOL)isFileExistAtPath:(NSString*)fileFullPath {
    BOOL isExist = NO;
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:fileFullPath];
    return isExist;
}

@end
