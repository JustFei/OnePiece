//
//  AppDelegate.m
//  OnePiece
//
//  Created by JustFei on 2016/11/9.
//  Copyright © 2016年 manridy. All rights reserved.
//

#import "AppDelegate.h"
#import "OPMainViewController.h"
#import "LoginViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <BmobSDK/Bmob.h>
#import <Bugly/Bugly.h>

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Bugly startWithAppId:@"7965093895"];
    
    //真机下保存本地日志和crash
    [self redirectNSLogToDocumentFolder];
    
    if (ScreenHeight > 480) { // 这里以(iPhone4S)为准
        self.autoSizeScaleX = ScreenWidth/320;
        self.autoSizeScaleY = ScreenHeight/568;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    if (ScreenHeight > 568) { // 这里以(iPhone5S)为准
        self.autoSizeScaleX = ScreenWidth/375;
        self.autoSizeScaleY = ScreenHeight/667;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    if (ScreenHeight > 736) { // 这里以(iPhone5S)为准
        self.autoSizeScaleX = ScreenWidth/414;
        self.autoSizeScaleY = ScreenHeight/736;
    }else{
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Login"]) {
        BOOL login = [[NSUserDefaults standardUserDefaults] boolForKey:@"Login"];
        if (login) {
            OPMainViewController *mainVC = [[OPMainViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        }else {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
        }
    }else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    }
    
    
    [self registSocialApp];
    [self registBmob];
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    
    [NSThread sleepForTimeInterval:4.0];
    
    return YES;
}


- (void)registSocialApp
{
    [ShareSDK registerApp:@"194fa5d1d46cc"
         activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                           @(SSDKPlatformTypeWechat),
                           @(SSDKPlatformTypeQQ),]
                onImport:^(SSDKPlatformType platformType) {
                    switch (platformType)
                    {
                        case SSDKPlatformTypeWechat:
                            [ShareSDKConnector connectWeChat:[WXApi class]];
                            break;
                        case SSDKPlatformTypeQQ:
                            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                            break;
                        case SSDKPlatformTypeSinaWeibo:
                            [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                            break;
                        default:
                            break;
                    }
                }
         onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
             switch (platformType)
             {
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:@"3203517801"
                                               appSecret:@"27a4d610927c6940137bdf7deb728841"
                                             redirectUri:@"http://www.manridy.com"
                                                authType:SSDKAuthTypeBoth];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:@"wxe88cfb783805f143"
                                           appSecret:@"12a6a9a23d1cf2294ef14623d70935bb"];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:@"1105847010"
                                          appKey:@"WA0QLptQWILMzJ7T"
                                        authType:SSDKAuthTypeBoth];
                     break;
                     
                 default:
                     break;
             }
         }];
}

- (void)redirectNSLogToDocumentFolder
{
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){ //在模拟器不保存到文件中
        return;
    }
    //将NSlog打印信息保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",dateStr];
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    //未捕获的Objective-C异常日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}
void UncaughtExceptionHandler(NSException* exception)
{
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    //将crash日志保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logDirectory]) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *logFilePath = [logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSString *crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n", dateStr, name, reason, strSymbols];
    //把错误日志写到文件中
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
    //把错误日志发送到邮箱
//    NSString *urlStr = [NSString stringWithFormat:@"mailto://test@163.com?subject=bug报告&body=感谢您的配合!<br><br><br>错误详情:<br>%@",crashString ];
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:url];
}

- (void)registBmob
{
    [Bmob registerWithAppKey:@"396cb5d4f043900116500b8ad9fa2af3"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
